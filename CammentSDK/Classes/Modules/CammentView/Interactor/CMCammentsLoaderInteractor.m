//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AWSIoT/AWSIoT.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsLoaderInteractor.h"
#import "CMCamment.h"
#import "CMServerListener.h"
#import "CMServerListenerCredentials.h"
#import "CMAPIDevcammentClient.h"
#import "CMServerMessage.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "TCBlobDownloader.h"
#import "TCBlobDownloadManager.h"
#import "CMCammentBuilder.h"
#import "CMCammentStatus.h"
#import "CMServerMessage+TypeMatching.h"
#import "CMBotAction.h"
#import "CMAdsDemoBot.h"
#import "CMBotCamment.h"

@interface CMCammentsLoaderInteractor ()

@property(nonatomic, strong) RACSubject *serverMessageSubject;

@end

@implementation CMCammentsLoaderInteractor

- (instancetype)initWithNewMessageSubject:(RACSubject *)serverMessageSubject {

    self = [super init];
    if (self) {
        self.cammentsLimit = @"100";
        self.canLoadMoreCamments = YES;
        self.paginationKey = nil;
        self.serverMessageSubject = serverMessageSubject;
        __weak typeof(self) __weakSelf = self;
        [[[self.serverMessageSubject deliverOnMainThread]
                takeUntil:self.rac_willDeallocSignal]
                subscribeNext:^(CMServerMessage *_Nullable message) {
                    [message matchCamment:^(CMCamment *camment) {
                        [__weakSelf downloadCamment:camment];
                    }];

                    [message matchCammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {
                        [__weakSelf.output didReceiveCammentDeletedMessage:cammentDeletedMessage];
                    }];

                    [message matchCammentDelivered:^(CMCammentDeliveredMessage *cammentDelivered) {
                        [__weakSelf.output didReceiveDeliveryConfirmation:cammentDelivered.cammentUuid];
                    }];

                    [message matchAdBanner:^(CMAdBanner *adBanner) {
                        [__weakSelf prepareAndDisplayAds:adBanner];
                    }];
                }];
    }

    return self;
}

- (void)prepareAndDisplayAds:(CMAdBanner *)banner {

    CMBotAction *action = [[CMBotAction alloc] init];
    action.botUuid = kCMAdsDemoBotUUID;
    action.action = kCMAdsDemoBotPlayVideoAction;

    NSMutableDictionary *params = [NSMutableDictionary new];

    if (banner.thumbnailURL) {
        params[kCMAdsDemoBotPlaceholderURLParam] = banner.thumbnailURL;
    }

    if (banner.videoURL) {
        params[kCMAdsDemoBotVideoURLParam] = banner.videoURL;
    }

    if (banner.openURL) {
        params[kCMAdsDemoBotURLParam] = banner.openURL;
    }

    action.params = params;
    CMBotCamment *botCamment = [[CMBotCamment alloc] initWithURL:banner.thumbnailURL
                                                       botAction:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        [_output didReceiveNewBotCamment:botCamment];
    });
}

- (void)resetPaginationKey {
    self.paginationKey = nil;
    self.canLoadMoreCamments = YES;
}


- (void)loadNextPageOfCamments:(NSString *)groupUUID {
    if (!groupUUID) {return;}
    @weakify(self);
    NSLog(@"Load page %@", self.paginationKey);
    BOOL isFirstPage = [self.paginationKey length] == 0;
    [[[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidCammentsGet:groupUUID
                                                                      lastKey:self.paginationKey ?: @""
                                                                        limit:self.cammentsLimit]
            continueWithExecutor:[AWSExecutor mainThreadExecutor]
                       withBlock:^id(AWSTask<CMAPICammentList *> *t) {
                           NSLog(@"Loaded");
                if (!t.error && t.result && [t.result isKindOfClass:[CMAPICammentList class]]) {
                    self.paginationKey = t.result.lastKey;
                    self.canLoadMoreCamments = t.result.lastKey != nil;
                    NSArray *camments = [t.result items];
                    NSArray *result = [camments.rac_sequence map:^id(CMAPICamment *value) {
                        CMCammentStatus *cammentStatus = [[CMCammentStatus alloc]
                                initWithDeliveryStatus:[value.delivered boolValue] ? CMCammentDeliveryStatusSeen : CMCammentDeliveryStatusSent
                                             isWatched:YES];
                        return [[[[[[[[[[[CMCammentBuilder camment]
                                withShowUuid:value.showUuid]
                                withUserGroupUuid:value.userGroupUuid]
                                withUuid:value.uuid]
                                withRemoteURL:value.url]
                                withThumbnailURL:value.thumbnail]
                                withUserCognitoIdentityId:value.userCognitoIdentityId]
                                withIsDeleted:NO]
                                withShouldBeDeleted:NO]
                                withStatus:cammentStatus] build];
                    }].array;
                    [self.output didFetchCamments:result canLoadMore:self.canLoadMoreCamments firstPage:isFirstPage];
                } else {
                    [self.output didFailToLoadCamments:t.error];
                };
                return nil;
            }];
}

- (void)downloadCamment:(CMCamment *)camment {
    TCBlobDownloadManager *sharedManager = [TCBlobDownloadManager sharedInstance];
    if (!camment.remoteURL) {
        NSLog(@"no remote url for %@", camment);
        return;
    }

    TCBlobDownloader *downloader = [sharedManager startDownloadWithURL:[[NSURL alloc] initWithString:camment.remoteURL]
                                                            customPath:nil
                                                         firstResponse:^(NSURLResponse *response) {

                                                         }
                                                              progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress) {

                                                              }
                                                                 error:^(NSError *error) {
                                                                     DDLogError(@"Error on downloading camment %@", error);
                                                                 }
                                                              complete:^(BOOL downloadFinished, NSString *pathToFile) {
                                                                  if (downloadFinished && pathToFile) {
                                                                      CMCammentBuilder *builder = [[CMCammentBuilder cammentFromExistingCamment:camment]
                                                                              withLocalURL:pathToFile];
                                                                      [self.output didReceiveNewCamment:[builder build]];
                                                                  }
                                                              }];
}

- (void)dealloc {
    [[TCBlobDownloadManager sharedInstance] cancelAllDownloadsAndRemoveFiles:YES];
}

@end
