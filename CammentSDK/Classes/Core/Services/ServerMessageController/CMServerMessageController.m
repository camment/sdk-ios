//
//  CMServerMessageController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 21.11.2017.
//

#import "CMServerMessageController.h"
#import "CMServerMessage.h"
#import "RACSubject.h"
#import "CammentSDK.h"
#import "CMSDKNotificationPresenterPresenter.h"
#import "CMStore.h"
#import "CMAuthStatusChangedEventContext.h"
#import "CMServerMessage+TypeMatching.h"
#import "CMGroupManagementInteractor.h"
#import "CMAnalytics.h"
#import "CMUsersGroupBuilder.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@implementation CMServerMessageController

- (instancetype)initWithSdkDelegate:(id <CMCammentSDKDelegate>)sdkDelegate
              notificationPresenter:(CMSDKNotificationPresenterPresenter *)notificationPresenter
                              store:(CMStore *)store
          groupManagementInteractor:(CMGroupManagementInteractor *)groupManagementInteractor {
    self = [super init];
    if (self) {
        self.sdkDelegate = sdkDelegate;
        self.notificationPresenter = notificationPresenter;
        self.groupManagementInteractor = groupManagementInteractor;
        self.groupManagementInteractor.output = self;
        self.store = store;
    }

    return self;
}

- (void)handleServerMessage:(CMServerMessage *)message {

    __block BOOL shouldPassToObservers = YES;

    [message matchMembershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {
        shouldPassToObservers = NO;
        [self presentMembershipRequestAlert:membershipRequestMessage];
    }];

    [message matchMembershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {
        shouldPassToObservers = NO;
        [self.groupManagementInteractor joinUserToGroup:membershipAcceptedMessage.group];
        [self handleMembershipAcceptedMessage:membershipAcceptedMessage];
    }];

    [message matchUserRemoved:^(CMUserRemovedMessage *userRemovedMessage) {
        shouldPassToObservers = NO;
        CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];
        [self.groupManagementInteractor removeUser:userRemovedMessage.removedUser.cognitoUserId
                                         fromGroup:userRemovedMessage.userGroupUuid];
        if ([userRemovedMessage.removedUser.cognitoUserId isEqualToString:context.user.cognitoUserId]) {
            [self handleRemovedFromGroupMessage:userRemovedMessage];
        }
    }];

    [message matchCamment:^(CMCamment *camment) {
        [self confirmCammentMessageDelivery:camment.uuid];
    }];

    if (shouldPassToObservers) {
        [self.store.serverMessagesSubject sendNext:message];
    }
}

- (void)confirmCammentMessageDelivery:(NSString *)uuid {
    if (!uuid) {return;}

    [[[CMAPIDevcammentClient defaultAPIClient] cammentsCammentUuidPost:uuid]
            continueWithBlock:^id(AWSTask<id> *t) {
                if (t.error) {
                    DDLogError(@"Coudn't confirm camment delivery, error :%@", t.error);
                }
                return nil;
            }];
}

- (void)handleRemovedFromGroupMessage:(CMUserRemovedMessage *)message {
    [self.notificationPresenter presentRemovedFromGroupAlert:message];
}

- (void)presentMembershipRequestAlert:(CMMembershipRequestMessage *)message {
    __weak typeof(self) __weakSelf = self;
    [self.notificationPresenter presentMembershipRequestAlert:message
                                                     onAccept:^{
                                                         typeof(__weakSelf) __strongSelf = __weakSelf;
                                                         if (!__strongSelf) {return;}

                                                         if (__strongSelf.sdkDelegate && [__strongSelf.sdkDelegate respondsToSelector:@selector(didAcceptJoiningRequest:)]) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 CMShowMetadata *metadata = [CMShowMetadata new];
                                                                 metadata.uuid = message.show.uuid;
                                                                 [__strongSelf.sdkDelegate didAcceptJoiningRequest:metadata];
                                                             });
                                                         }

                                                         CMAuthStatusChangedEventContext *context = [CMStore instance].authentificationStatusSubject.first;

                                                         CMUsersGroup *updatedGroup = [[[CMUsersGroupBuilder usersGroupFromExistingUsersGroup:message.group]
                                                                 withOwnerCognitoUserId:context.user.cognitoUserId] build];
                                                         [__strongSelf.groupManagementInteractor joinUserToGroup:updatedGroup];
                                                         [__strongSelf.groupManagementInteractor replyWithJoiningPermissionForUser:message.joiningUser
                                                                                                                             group:updatedGroup
                                                                                                                   isAllowedToJoin:YES
                                                                                                                              show:message.show];
                                                         [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventAcceptJoinRequest];
                                                     }
                                                    onDecline:^{
                                                        typeof(__weakSelf) __strongSelf = __weakSelf;
                                                        if (!__strongSelf) {return;}

                                                        [__strongSelf.groupManagementInteractor replyWithJoiningPermissionForUser:message.joiningUser
                                                                                                                            group:message.group
                                                                                                                  isAllowedToJoin:NO
                                                                                                                             show:message.show];
                                                        [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventDeclineJoinRequest];
                                                    }];
}

- (void)handleMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)message {

    CMShowMetadata *metadata = [CMShowMetadata new];
    CMShow *show = message.show;
    if (show) {
        metadata.uuid = show.uuid;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didJoinToShow:)]) {
            [self.sdkDelegate didJoinToShow:metadata];
        } else if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didAcceptInvitationToShow:)]) {
            [self.sdkDelegate didAcceptInvitationToShow:metadata];
        }

        [self.notificationPresenter presentMembershipAcceptedAlert:message];
    });
}


@end
