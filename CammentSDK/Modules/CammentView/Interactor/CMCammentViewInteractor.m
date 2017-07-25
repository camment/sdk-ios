//
//  CMCammentViewCMCammentViewInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMCammentViewInteractor.h"
#import <ReactiveObjC.h>
#import <AsyncDisplayKit/ASDisplayNode.h>
#import "CMCammentUploader.h"
#import "CMCammentInRequest.h"
#import "CMDevcammentClient.h"
#import "Camment.h"
#import "CammentBuilder.h"
#import "UsersGroup.h"
#import "CMStore.h"
#import "RACSignal+SignalHelpers.h"
#import "CMCammentPostingOperation.h"

NSString *const bucketFormatPath = @"https://s3.eu-central-1.amazonaws.com/camment-camments/uploads/%@.mp4";

@interface CMCammentViewInteractor ()

@property(nonatomic, strong) CMDevcammentClient *client;
@property(nonatomic, strong) NSOperationQueue *cammentPostingQueue;

@property(nonatomic, strong) NSMutableArray *cammentsToUpload;

@end

@implementation CMCammentViewInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [CMDevcammentClient defaultClient];
        self.cammentPostingQueue = [[NSOperationQueue alloc] init];
        self.cammentPostingQueue.name = @"Camment posting queue";
        self.cammentPostingQueue.maxConcurrentOperationCount = 1;
        self.cammentPostingQueue.qualityOfService = NSOperationQualityOfServiceBackground;
    }
    return self;
}

- (RACSignal<UsersGroup *> *)createEmptyGroup {
    return [RACSignal<UsersGroup *> createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[self.client usergroupsPost] continueWithBlock:^id(AWSTask<id> *t) {
            if ([t.result isKindOfClass:[CMUsergroup class]]) {
                CMUsergroup *group = t.result;
                UsersGroup *result = [[UsersGroup alloc] initWithUuid:group.uuid
                                                   ownerCognitoUserId:group.userCognitoIdentityId
                                                            timestamp:group.timestamp];
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

- (void)uploadCamment:(Camment *)camment {

    RACSignal<UsersGroup *> *createUserGroupIfNeededSignal = nil;

    UsersGroup *group = [CMStore instance].activeGroup;
    if (group) {
        createUserGroupIfNeededSignal = [RACSignal signalWithNext:group];
    } else {
        createUserGroupIfNeededSignal = [[self createEmptyGroup] doNext:^(UsersGroup *x) {
            [[CMStore instance] setActiveGroup:x];
        }];
    }

    __block Camment *cammentToUpload = nil;
    [createUserGroupIfNeededSignal subscribeNext:^(UsersGroup *usersGroup) {
        cammentToUpload = [[[CammentBuilder cammentFromExistingCamment:camment]
                withUserGroupUuid:usersGroup.uuid]
                build];
        CMCammentPostingOperation *postingOperation = [[CMCammentPostingOperation alloc]
                initWithCamment:cammentToUpload
                cammentUploader:[CMCammentUploader instance]
                  cammentClient:[CMDevcammentClient defaultClient]];

        postingOperation.maxRetries = 5;

        [postingOperation setPostingCompletionBlock:^(Camment *uploadedCamment, NSError *error, CMCammentPostingOperation *currentOperation) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.output interactorDidUploadCamment:uploadedCamment];
                });
                return;
            }
        }];

        [self.cammentPostingQueue addOperation:postingOperation];
        [postingOperation start];
    } error:^(NSError *error) {

    }];
}

- (void)deleteCament:(Camment *)camment {
    NSString *cammentUuid = camment.uuid;
    NSString *groupUuid = camment.userGroupUuid ?: [CMStore instance].activeGroup.uuid;
    if (!cammentUuid || !groupUuid) {return;}
    [[[CMDevcammentClient defaultClient] usergroupsGroupUuidCammentsCammentUuidDelete:cammentUuid
                                                                            groupUuid:groupUuid]
            continueWithBlock:^id(AWSTask<id> *t) {
                if (t.error) {
                    DDLogError(@"Error while camment deletion %@", t.error);
                } else {
                    DDLogVerbose(@"Camment has been deleted %@", camment);
                }
                return nil;
            }];
}

@end
