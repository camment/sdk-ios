//
//  CMCammentViewCMCammentViewInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <AsyncDisplayKit/ASDisplayNode.h>
#import "CMCammentViewInteractor.h"
#import "CMCammentUploader.h"
#import "CMAPICammentInRequest.h"
#import "CMAPIDevcammentClient.h"
#import "CMCamment.h"
#import "CMCammentBuilder.h"
#import "CMUsersGroup.h"
#import "CMStore.h"
#import "CMCammentPostingOperation.h"
#import "CMShowMetadata.h"
#import "RACSignal+SignalHelpers.h"

NSString *const CMCammentViewInteractorErrorDomain = @"tv.camment.CMCammentViewInteractorErrorDomain";

@interface CMCammentViewInteractor ()

@property(nonatomic, strong) CMCammentUploader *cammentUploader;
@property(nonatomic, strong) NSOperationQueue *cammentPostingQueue;

@property(nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *cammentUploadingRetries;

@end

@implementation CMCammentViewInteractor

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"`- init` is not a valid initializer. Use `- initWithCammentUploader:` instead."
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithCammentUploader:(CMCammentUploader *)cammentUploader {
    self = [super init];
    if (self) {
        self.cammentUploader = cammentUploader;
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
    CMAPIUsergroupInRequest *usergroupInRequest = [CMAPIUsergroupInRequest new];
    usergroupInRequest.showId = [CMStore instance].currentShowMetadata.uuid;
    return [RACSignal<CMUsersGroup *> createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        if (!usergroupInRequest.showId) {
            NSError *error = [NSError errorWithDomain:@"tv.camment.sdk"
                                                 code:CMCammentViewInteractorErrorMissingRequiredParameters
                                             userInfo:@{
                                                     NSLocalizedFailureReasonErrorKey : @"Could not upload camment while show uuid is empty"
                                             }];
            [subscriber sendError:error];
            return nil;
        }

        [[[CMAPIDevcammentClient defaultClient] usergroupsPost:usergroupInRequest] continueWithBlock:^id(AWSTask<id> *t) {
            if ([t.result isKindOfClass:[CMAPIUsergroup class]]) {
                CMAPIUsergroup *group = t.result;
                CMUsersGroup *result = [[CMUsersGroup alloc] initWithUuid:group.uuid
                                                                 showUuid:[CMStore instance].currentShowMetadata.uuid
                                                       ownerCognitoUserId:group.userCognitoIdentityId
                                                        hostCognitoUserId:group.userCognitoIdentityId
                                                                timestamp:group.timestamp
                                                           invitationLink:nil
                                                                    users:@[]
                                                                 isPublic:group.isPublic.boolValue];
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
    if (!camment) {
        [self handleCammentUploadingError:[NSError errorWithDomain:CMCammentViewInteractorErrorDomain
                                                              code:CMCammentViewInteractorErrorMissingRequiredParameters
                                                          userInfo:@{}]
                                  camment:camment];
        return;
    }

    if (!camment.uuid) {
        [self handleCammentUploadingError:[NSError errorWithDomain:CMCammentViewInteractorErrorDomain
                                                              code:CMCammentViewInteractorErrorProvidedParametersAreIncorrect
                                                          userInfo:@{}]
                                  camment:camment];
        return;
    }

    NSNumber *retriesCount = self.cammentUploadingRetries[camment.uuid] ?: @0;
    NSInteger nextAttemptNumber = retriesCount.integerValue + 1;
    self.cammentUploadingRetries[camment.uuid] = @(nextAttemptNumber);

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
    if (!camment) {
        [self handleCammentUploadingError:[NSError errorWithDomain:CMCammentViewInteractorErrorDomain
                                                              code:CMCammentViewInteractorErrorMissingRequiredParameters
                                                          userInfo:@{}]
                                  camment:camment];
        return;
    }

    if (!camment.localURL || !camment.uuid) {
        [self handleCammentUploadingError:[NSError errorWithDomain:CMCammentViewInteractorErrorDomain
                                                              code:CMCammentViewInteractorErrorProvidedParametersAreIncorrect
                                                          userInfo:@{}]
                                  camment:camment];
        return;
    }

    NSURL *urlToUpload = [[NSURL alloc] initWithString:camment.localURL];
    if (!urlToUpload) {
        [self handleCammentUploadingError:[NSError errorWithDomain:CMCammentViewInteractorErrorDomain
                                                              code:CMCammentViewInteractorErrorProvidedParametersAreIncorrect
                                                          userInfo:@{}]
                                  camment:camment];
        return;
    }

    __weak typeof(self) __weakSelf = self;
    [[self.cammentUploader uploadVideoAsset:urlToUpload
                                       uuid:camment.uuid]
            subscribeError:^(NSError *error) {
                [__weakSelf handleCammentUploadingError:error camment:camment];
            }
                 completed:^{
                     CMAPICammentInRequest *cammentInRequest = [[CMAPICammentInRequest alloc] init];
                     cammentInRequest.uuid = camment.uuid;
                     cammentInRequest.showAt = @([camment.showAt integerValue]);
                     DDLogVerbose(@"Posting camment %@", camment);

                     [[[CMAPIDevcammentClient defaultClient] usergroupsGroupUuidCammentsPost:camment.userGroupUuid
                                                                                        body:cammentInRequest]
                             continueWithBlock:^id(AWSTask<CMAPICamment *> *t) {
                                 if (t.error) {
                                     [__weakSelf handleCammentUploadingError:t.error camment:camment];
                                 } else {
                                     CMAPICamment *cmCamment = t.result;
                                     CMCamment *uploadedCamment = [[[[[[[CMCammentBuilder cammentFromExistingCamment:camment]
                                             withUuid:cmCamment.uuid ?: camment.uuid]
                                             withShowUuid:cmCamment.showUuid ?: camment.showUuid]
                                             withRemoteURL:cmCamment.url ?: camment.remoteURL]
                                             withUserGroupUuid:cmCamment.userGroupUuid ?: camment.userGroupUuid]
                                             withLocalURL:camment.localURL]
                                             build];
                                     [__weakSelf completeCammentUploadingTask:uploadedCamment];
                                 }
                                 return nil;
                             }];
                 }];
}

- (void)handleCammentUploadingError:(NSError *)error camment:(CMCamment *)camment {
    DDLogVerbose(@"Camment uploading error %@", error);

    if ([error.domain isEqualToString:CMCammentViewInteractorErrorDomain]) {
        [self.output interactorFailedToUploadCamment:camment error:error];
        return;
    }

    NSNumber *retriesCount = self.cammentUploadingRetries[camment.uuid] ?: @0;
    NSInteger nextAttemptNumber = retriesCount.integerValue + 1;

    if (nextAttemptNumber > _maxUploadRetries) {
        [self.output interactorFailedToUploadCamment:camment error:error];
        return;
    }

    DDLogVerbose(@"Start uploading attempt %ld", (long)nextAttemptNumber);
    [self uploadCamment:camment];
}

- (void)completeCammentUploadingTask:(CMCamment *)camment {
    DDLogVerbose(@"Camment has been sent %@", camment);

    if (camment.uuid) {
        [self.cammentUploadingRetries removeObjectForKey:camment.uuid];
    }

    CMCammentBuilder *cammentBuilder = [[CMCammentBuilder cammentFromExistingCamment:camment]
            withStatus:[[CMCammentStatus alloc] initWithDeliveryStatus:CMCammentDeliveryStatusSent
                                                             isWatched:YES]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.output interactorDidUploadCamment:[cammentBuilder build]];
    });
}

- (void)deleteCament:(CMCamment *)camment {
    NSString *cammentUuid = camment.uuid;
    NSString *groupUuid = camment.userGroupUuid ?: [CMStore instance].activeGroup.uuid;
    if (!cammentUuid || !groupUuid) { return; }
    [[[CMAPIDevcammentClient defaultClient] usergroupsGroupUuidCammentsCammentUuidDelete:cammentUuid
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
