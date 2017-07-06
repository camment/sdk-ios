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
#import "Camment.h"
#import "CMServerListener.h"
#import "CMServerListenerCredentials.h"
#import "CMDevcammentClient.h"
#import "ServerMessage.h"

@interface CMCammentsLoaderInteractor ()
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMCammentsLoaderInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.disposable = [[[[CMServerListener instance] messageSubject] deliverOnMainThread] subscribeNext:^(ServerMessage *_Nullable message) {
            [message
                    matchInvitation:^(Invitation *invitation) {
                    }
                            camment:^(Camment *camment) {
                                [self.output didReceiveNewCamment:camment];
                            } userJoined:^(UserJoinedMessage *userJoinedMessage) {
                        [self.output didReceiveUserJoinedMessage:userJoinedMessage];
                    } cammentDeleted:^(CammentDeletedMessage *cammentDeletedMessage) {
                        [self.output didReceiveCammentDeletedMessage:cammentDeletedMessage];
                    }];
        }];
    }
    return self;
}

- (void)fetchCachedCamments:(NSString *)groupUUID {
    if (!groupUUID) {return;}
    [[[CMDevcammentClient defaultClient] usergroupsGroupUuidCammentsGet:groupUUID] continueWithBlock:^id(AWSTask<CMCammentList *> *t) {

        if ([t.result isKindOfClass:[CMCammentList class]]) {
            NSArray *camments = [(CMCammentList *) t.result items];
            NSArray *result = [camments.rac_sequence map:^id(CMCamment *value) {
                return [[Camment alloc] initWithShowUuid:value.showUuid
                                           userGroupUuid:value.userGroupUuid
                                                    uuid:value.uuid
                                               remoteURL:value.url
                                                localURL:nil
                                            thumbnailURL:value.thumbnail
                                   userCognitoIdentityId:value.userCognitoIdentityId
                                              localAsset:nil];
            }].array;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_output didFetchCamments:result];
            });
        };
        return nil;
    }];
}

@end
