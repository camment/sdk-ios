//
//  CMCammentViewCMCammentViewInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMCammentViewInteractor.h"
#import "ReactiveObjC.h"
#import <AsyncDisplayKit/ASDisplayNode.h>
#import "CMCammentUploader.h"
#import "CMAPICammentInRequest.h"
#import "CMAPIDevcammentClient.h"
#import "CMCamment.h"
#import "CMCammentBuilder.h"
#import "CMUsersGroup.h"
#import "CMStore.h"
#import "RACSignal+SignalHelpers.h"
#import "CMCammentPostingOperation.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@interface CMCammentViewInteractor ()

@property(nonatomic, strong) CMAPIDevcammentClient *client;
@property(nonatomic, strong) NSOperationQueue *cammentPostingQueue;

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *cammentUploadingRetries;

@end

@implementation CMCammentViewInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [CMAPIDevcammentClient defaultAPIClient];
        self.maxUploadRetries = 3;
        self.cammentPostingQueue = [[NSOperationQueue alloc] init];
        self.cammentPostingQueue.name = @"Camment posting queue";
        self.cammentPostingQueue.maxConcurrentOperationCount = 1;
        self.cammentPostingQueue.qualityOfService = NSOperationQualityOfServiceBackground;
        self.cammentUploadingRetries = [NSMutableDictionary new];
    }
    return self;
}

- (RACSignal<CMUsersGroup *> *)createEmptyGroup {
    return [RACSignal<CMUsersGroup *> createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[self.client usergroupsPost] continueWithBlock:^id(AWSTask<id> *t) {
            if ([t.result isKindOfClass:[CMAPIUsergroup class]]) {
                CMAPIUsergroup *group = t.result;
                CMUsersGroup *result = [[CMUsersGroup alloc] initWithUuid:group.uuid
                                                       ownerCognitoUserId:group.userCognitoIdentityId
                                                                timestamp:group.timestamp
                                                           invitationLink:nil];
                DDLogVerbose(@"Created new group %@", result);
                [subscriber sendNext:result];
            } else {
                DDLogError(@"%@", t.error);
                [subscriber sendError:t.error];
            }
            return nil;
        }];
        return nil;
    }];
}

- (void)uploadCamment:(CMCamment *)camment {

    if (camment.uuid) {
        NSNumber *retriesCount = self.cammentUploadingRetries[camment.uuid] ?: @0;
        NSInteger nextAttemptNumber = retriesCount.integerValue + 1;
        self.cammentUploadingRetries[camment.uuid] = @(nextAttemptNumber);
    }
    
    RACSignal<CMUsersGroup *> *createUserGroupIfNeededSignal = nil;

    CMUsersGroup *group = [CMStore instance].activeGroup;
    if (group) {
        createUserGroupIfNeededSignal = [RACSignal signalWithNext:group];
    } else {
        createUserGroupIfNeededSignal = [[self createEmptyGroup] doNext:^(CMUsersGroup *x) {
            [[CMStore instance] setActiveGroup:x];
        }];
    }

    __block CMCamment *cammentToUpload = nil;
    [createUserGroupIfNeededSignal subscribeNext:^(CMUsersGroup *usersGroup) {
        cammentToUpload = [[[CMCammentBuilder cammentFromExistingCamment:camment]
                withUserGroupUuid:usersGroup.uuid]
                build];
        [self postCamment:cammentToUpload];
    }                                      error:^(NSError *error) {
        [self handleCammentUploadingError:error camment:camment];
    }];
}

- (void)postCamment:(CMCamment *)camment {
    __weak typeof(self) __weakSelf = self;
    [[[CMCammentUploader instance] uploadVideoAsset:[[NSURL alloc] initWithString:camment.localURL]
                                               uuid:camment.uuid]
            subscribeError:^(NSError *error) {
                [__weakSelf handleCammentUploadingError:error camment:camment];
            }
                 completed:^{
                     CMAPICammentInRequest *cammentInRequest = [[CMAPICammentInRequest alloc] init];
                     cammentInRequest.uuid = camment.uuid;
                     DDLogVerbose(@"Posting camment %@", camment);

                     [[[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidCammentsPost:camment.userGroupUuid
                                                                                           body:cammentInRequest]
                             continueWithBlock:^id(AWSTask<CMAPICamment *> *t) {
                                 if (t.error) {
                                     [__weakSelf handleCammentUploadingError:t.error camment:camment];
                                 } else {
                                     CMAPICamment *cmCamment = t.result;
                                     CMCamment *uploadedCamment = [[[[[[[CMCammentBuilder cammentFromExistingCamment:camment]
                                             withUuid:cmCamment.uuid]
                                             withShowUuid:cmCamment.showUuid]
                                             withRemoteURL:cmCamment.url]
                                             withUserGroupUuid:cmCamment.userGroupUuid]
                                             withLocalURL:nil]
                                             build];
                                     [__weakSelf completeCammentUploadingTask:uploadedCamment];
                                 }

                                 return nil;
                             }];
                 }];
}

- (void)handleCammentUploadingError:(NSError *)error camment:(CMCamment *)camment {
    DDLogVerbose(@"Camment uploading error %@", error);

    if (!camment.uuid) { return; }

    NSNumber *retriesCount = self.cammentUploadingRetries[camment.uuid] ?: @0;
    NSInteger nextAttemptNumber = retriesCount.integerValue + 1;

    if (nextAttemptNumber > _maxUploadRetries) { return; }
    DDLogVerbose(@"Start uploading attempt %d", nextAttemptNumber);
    [self uploadCamment:camment];
}

- (void)completeCammentUploadingTask:(CMCamment *)camment {
    DDLogVerbose(@"Camment has been sent %@", camment);

    if (camment.uuid) {
        [self.cammentUploadingRetries removeObjectForKey:camment.uuid];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output interactorDidUploadCamment:camment];
    });
}

- (void)deleteCament:(CMCamment *)camment {
    NSString *cammentUuid = camment.uuid;
    NSString *groupUuid = camment.userGroupUuid ?: [CMStore instance].activeGroup.uuid;
    if (!cammentUuid || !groupUuid) {return;}
    [[[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidCammentsCammentUuidDelete:cammentUuid
                                                                                  groupUuid:groupUuid]
            continueWithBlock:^id(AWSTask<id> *t) {
                if (t.error) {
                    DDLogError(@"Error while camment deletion %@", t.error);
                } else {
                    [self.output interactorDidDeleteCamment:camment];
                }
                return nil;
            }];
}

@end
