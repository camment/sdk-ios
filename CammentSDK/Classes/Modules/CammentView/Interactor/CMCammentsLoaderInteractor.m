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

@interface CMCammentsLoaderInteractor ()
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMCammentsLoaderInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.disposable = [[[[CMServerListener instance] messageSubject] deliverOnMainThread] subscribeNext:^(CMServerMessage *_Nullable message) {
            [message matchInvitation:^(CMInvitation *invitation) {
                    }
                             camment:^(CMCamment *camment) {
                                 [self.output didReceiveNewCamment:camment];
                             }
                          userJoined:^(CMUserJoinedMessage *userJoinedMessage) {
                              [self.output didReceiveUserJoinedMessage:userJoinedMessage];
                          }
                      cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {
                          [self.output didReceiveCammentDeletedMessage:cammentDeletedMessage];
                      }
                   membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {
                   }
                  membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}];
        }];
    }
    return self;
}

- (void)fetchCachedCamments:(NSString *)groupUUID {
    if (!groupUUID) {return;}
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
                                                 botAction:nil];
            }].array;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_output didFetchCamments:result];
            });
        };
        return nil;
    }];
}

- (void)dealloc {

}

@end
