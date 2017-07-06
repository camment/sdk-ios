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

NSString *const bucketFormatPath = @"https://s3.eu-central-1.amazonaws.com/camment-camments/uploads/%@.mp4";

@interface CMCammentViewInteractor ()
@property(nonatomic, strong) CMDevcammentClient *client;
@end

@implementation CMCammentViewInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [CMDevcammentClient defaultClient];
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

- (RACSignal<Camment *> *)uploadCamment:(Camment *)camment {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[[CMCammentUploader instance] uploadVideoAsset:[[NSURL alloc] initWithString:camment.localURL]
                                                   uuid:camment.uuid] subscribeCompleted:^{
            CMCammentInRequest *cammentInRequest = [[CMCammentInRequest alloc] init];
            cammentInRequest.uuid = camment.uuid;
            DDLogVerbose(@"Posting camment %@", camment);

            [[[CMDevcammentClient defaultClient] usergroupsGroupUuidCammentsPost:camment.userGroupUuid
                                                                            body:cammentInRequest]
                    continueWithBlock:^id(AWSTask<CMCamment *> *t) {
                        if (t.error) {
                            [subscriber sendError:t.error];
                        } else {
                            CMCamment *cmCamment = t.result;
                            Camment *uploadedCamment = [[[[[[[CammentBuilder cammentFromExistingCamment:camment]
                                    withUuid:cmCamment.uuid]
                                    withShowUuid:cmCamment.showUuid]
                                    withRemoteURL:cmCamment.url]
                                    withUserGroupUuid:cmCamment.userGroupUuid]
                                    withLocalURL:nil]
                                    build];
                            DDLogVerbose(@"Camment has been sent %@", uploadedCamment);
                            [subscriber sendNext:uploadedCamment];
                            [subscriber sendCompleted];
                        }
                        return nil;
                    }];
        }];

        return nil;
    }];
}

- (void)deleteCament:(Camment *)camment {
    NSString *cammentUuid = camment.uuid;
    NSString *groupUuid = camment.userGroupUuid ?: [CMStore instance].activeGroup.uuid;
    if (!cammentUuid || !groupUuid) { return; }
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