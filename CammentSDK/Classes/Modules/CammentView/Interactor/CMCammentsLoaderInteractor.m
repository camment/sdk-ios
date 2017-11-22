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

@interface CMCammentsLoaderInteractor ()

@property(nonatomic, strong) RACSubject *serverMessageSubject;

@end

@implementation CMCammentsLoaderInteractor

- (instancetype)initWithNewMessageSubject:(RACSubject *)serverMessageSubject {

    self = [super init];
    if (self) {
        self.serverMessageSubject = serverMessageSubject;
        __weak typeof(self) __weakSelf= self;
        [[[self.serverMessageSubject deliverOnMainThread]
                takeUntil:self.rac_willDeallocSignal]
                subscribeNext:^(CMServerMessage *_Nullable message) {
                    [message matchCamment:^(CMCamment *camment) {
                                [__weakSelf downloadCamment:camment];
                            }
                               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {
                                   [__weakSelf.output didReceiveUserJoinedMessage:userJoinedMessage];
                               }
                           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {
                               [__weakSelf.output didReceiveCammentDeletedMessage:cammentDeletedMessage];
                           }
                        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {
                        }
                       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {
                       }];
                }];
    }

    return self;
}

- (void)fetchCachedCamments:(NSString *)groupUUID {
    if (!groupUUID) {return;}
    @weakify(self);
    [[[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidCammentsGet:groupUUID] continueWithBlock:^id(AWSTask<CMAPICammentList *> *t) {

        if ([t.result isKindOfClass:[CMAPICammentList class]]) {
            NSArray *camments = [t.result items];
            NSArray *result = [camments.rac_sequence map:^id(CMAPICamment *value) {
                return [[CMCamment alloc] initWithShowUuid:value.showUuid
                                             userGroupUuid:value.userGroupUuid
                                                      uuid:value.uuid
                                                 remoteURL:value.url
                                                  localURL:nil
                                              thumbnailURL:value.thumbnail
                                     userCognitoIdentityId:value.userCognitoIdentityId
                                                localAsset:nil
                                               isMadeByBot:NO
                                                   botUuid:nil
                                                 botAction:nil
                                                 isDeleted:NO
                                           shouldBeDeleted:NO];
            }].array;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didFetchCamments:result];
            });
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
