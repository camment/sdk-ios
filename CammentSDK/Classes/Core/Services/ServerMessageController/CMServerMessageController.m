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
#import "CMSDKNotificationPresenter.h"
#import "CMStore.h"
#import "CMAuthStatusChangedEventContext.h"
#import "CMServerMessage+TypeMatching.h"
#import "CMGroupManagementInteractor.h"
#import "CMAnalytics.h"
#import "CMUsersGroupBuilder.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMUserContants.h"
#import "NSArray+RacSequence.h"
#import "CMUserBuilder.h"
#import "CMVideoSyncInteractor.h"

@implementation CMServerMessageController

- (instancetype)initWithSdkDelegate:(id <CMCammentSDKDelegate>)sdkDelegate
              notificationPresenter:(CMSDKNotificationPresenter *)notificationPresenter
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

    [message matchUserJoined:^(CMUserJoinedMessage *userJoinedMessage) {
        CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];
        BOOL imJoining = [userJoinedMessage.joinedUser.cognitoUserId isEqualToString:context.user.cognitoUserId];
        BOOL shouldShowToast = [self.store.activeGroupUsers.rac_sequence filter:^BOOL(CMUser *value) {
            return ![value.cognitoUserId isEqualToString:context.user.cognitoUserId];
        }].array.count > 0;

        [self.groupManagementInteractor joinUserToGroup:userJoinedMessage.usersGroup];

        if (imJoining) {
            [self handleMeJoinedMessage:userJoinedMessage];
        } else {
            if (![userJoinedMessage.usersGroup.ownerCognitoUserId isEqualToString:context.user.cognitoUserId]) {
                shouldShowToast = YES;
            }
            [self handleFriendJoinedMessage:userJoinedMessage shouldShowToast:shouldShowToast];
        }

        [self askForActualShowTimestampIfNeeded];
    }];

    [message matchUserRemoved:^(CMUserRemovedMessage *userRemovedMessage) {
        shouldPassToObservers = NO;
        CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];
        [self.groupManagementInteractor removeUser:userRemovedMessage.user.cognitoUserId
                                         fromGroup:userRemovedMessage.userGroupUuid];
        if (![userRemovedMessage.user.cognitoUserId isEqualToString:context.user.cognitoUserId]) {
            [self handleRemovedFromGroupMessage:userRemovedMessage];
        }
    }];

    [message matchCamment:^(CMCamment *camment) {
        CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];
        if (![context.user.cognitoUserId isEqualToString:camment.userCognitoIdentityId]) {
            [self confirmCammentMessageDelivery:camment.uuid];
        }
    }];

    [message matchUserGroupStateChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {
        NSString *userGroupUuid = userGroupStatusChangedMessage.userGroupUuid;
        if (![userGroupUuid isEqualToString:[CMStore instance].activeGroup.uuid]) {
            return;
        }

        CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];

        if (![context.user.cognitoUserId isEqualToString:userGroupStatusChangedMessage.user.cognitoUserId]) {
            [self handleUserGroupStateChanged:userGroupStatusChangedMessage];
        } else if ([userGroupStatusChangedMessage.state isEqualToString:CMUserBlockStatus.Blocked]) {
            [self handleMeBlockedInActiveGroup];
        }
    }];

    [message matchPlayerStateEvent:^(CMNewPlayerStateMessage *message) {
        [self handleVideoSyncMessage:message];
        shouldPassToObservers = NO;
    }];

    [message matchNeededPlayerState:^(CMNeededPlayerStateMessage *message) {
        [self handleNeededPlayerState:message];
        shouldPassToObservers = NO;
    }];

    [message matchNewGroupHost:^(CMNewGroupHostMessage *message) {
        [self handleNewGroupHost:message];
    }];

    [message matchOnlineStatusChanged:^(CMUserOnlineStatusChangedMessage *message) {
        [CMStore instance].activeGroupUsers = [[CMStore instance].activeGroupUsers map:^CMUser*(CMUser *user) {
            if ([user.cognitoUserId isEqualToString:message.userId]
                    && ![user.onlineStatus isEqualToString:message.status]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *toastMessageTemplate = [message.status isEqualToString:CMUserOnlineStatus.Online] ? CMLocalized(@"status.user_is_online") : CMLocalized(@"status.user_is_offline");
                    [self.notificationPresenter showToastMessage:[NSString stringWithFormat:toastMessageTemplate, user.username]];
                });

                return [[[CMUserBuilder userFromExistingUser:user] withOnlineStatus:message.status] build];
            }
            return user;
        }];
    }];

    if (shouldPassToObservers) {
        [self.store.serverMessagesSubject sendNext:message];
    }
}

- (void)handleNewGroupHost:(CMNewGroupHostMessage *)message {
    [[CMStore instance] updateHostUuid:message.hostId forGroup:message.groupUuid];
}

- (void)handleNeededPlayerState:(CMNeededPlayerStateMessage *)message {
    [[CMVideoSyncInteractor new] requestNewTimestampsFromHostAppIfNeeded:message.groupUUID];
}

- (void)askForActualShowTimestampIfNeeded {
    [[CMVideoSyncInteractor new] requestNewShowTimestampIfNeeded:[CMStore instance].activeGroup.uuid];
}

- (void)handleMeBlockedInActiveGroup {
    [[CammentSDK instance] leaveCurrentChatGroup];

    [self.notificationPresenter presentMeBlockedInGroupDialog];
}

- (void)handleUserGroupStateChanged:(CMUserGroupStatusChangedMessage *)message {
    CMUser *changedUser = message.user;
    [CMStore instance].activeGroupUsers = [[[CMStore instance] activeGroupUsers] map:^CMUser *(CMUser *user) {
        if ([changedUser.cognitoUserId isEqualToString:user.cognitoUserId]) {
            CMUser *updatedUser = [[[CMUserBuilder userFromExistingUser:user] withBlockStatus:message.state] build];
            return updatedUser;
        }
        return user;
    }];
    [[CMStore instance] refetchUsersInActiveGroup];
    NSString *username = message.user.username;
    NSString *notificationTemplate = [message.state isEqualToString:CMUserBlockStatus.Active] ? CMLocalized(@"toast.user_unblocked") : CMLocalized(@"toast.user_blocked");
    [self.notificationPresenter showToastMessage:[NSString stringWithFormat:notificationTemplate, username]];
}

- (void)handleFriendJoinedMessage:(CMUserJoinedMessage *)message shouldShowToast:(BOOL)showToast {
    if (showToast) {
        [self.notificationPresenter showToastMessage:[NSString stringWithFormat:CMLocalized(@"toast.user_joined"), message.joinedUser.username]];
    } else {
        [self.notificationPresenter presentUsersAreJoiningMessage:message];
    }
}

- (void)confirmCammentMessageDelivery:(NSString *)uuid {
    if (!uuid) {return;}

    [[[CMAPIDevcammentClient defaultAPIClient] cammentsCammentUuidPost:uuid]
            continueWithBlock:^id(AWSTask<id> *t) {
                if (t.error) {
                    DDLogError(@"Couldn't confirm camment delivery, error :%@", t.error);
                }
                return nil;
            }];
}

- (void)handleRemovedFromGroupMessage:(CMUserRemovedMessage *)message {
    [self.notificationPresenter presentRemovedFromGroupAlert:message];
}

- (void)handleMeJoinedMessage:(CMUserJoinedMessage *)message {

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

        [self.notificationPresenter presentUserJoinedToTheGroupAlert:message];
    });
}

- (void)handleVideoSyncMessage:(CMNewPlayerStateMessage *)message {
    if (![message.groupUuid isEqualToString:self.store.activeGroup.uuid]) { return; }

    CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];

    if ([context.user.cognitoUserId isEqualToString:self.store.activeGroup.hostCognitoUserId]) {
        return;
    }

    NSTimeInterval timeInterval = message.timestamp;

    [[CMStore instance].overlayDelegate cammentOverlayDidRequestPlayerState:^(BOOL isPlaying, NSTimeInterval playerTimeInterval) {

        BOOL shoudSync = (ABS(playerTimeInterval - timeInterval) > 60)
                || [CMStore instance].shoudForceSynced
                || isPlaying != message.isPlaying;

        if (!shoudSync) { return; }
        [CMStore instance].shoudForceSynced = NO;
        dispatch_async(dispatch_get_main_queue(), ^{

            [[NSNotificationCenter defaultCenter] postNotificationName:CMNewTimestampAvailableVideoPlayerNotification
                                                                object:[CammentSDK instance]
                                                              userInfo:@{
                                                                      CMNewTimestampKey : @(timeInterval),
                                                                      CMVideoIsPlayingKey : @(message.isPlaying)
                                                              }];
            NSString *hostUuid = [CMStore instance].activeGroup.hostCognitoUserId;
            CMUser *host = ([[[CMStore instance].activeGroupUsers rac_sequence] filter:^BOOL(CMUser *value) {
                return [value.cognitoUserId isEqualToString:hostUuid];
            }].array ?: @[]).firstObject;


            [_notificationPresenter showToastMessage:host.username ?
                [NSString stringWithFormat:CMLocalized(@"sync.you_synched_with_user"), host.username] :
                    CMLocalized(@"sync.you_synched_with_host")
            ];
        });
    }];
}

@end
