//
// Created by Alexander Fedosov on 05.09.17.
//

#import "CMServerMessage+TypeMatching.h"


@implementation CMServerMessage (TypeMatching)


- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler {
    [self matchCamment:cammentMatchHandler
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
        videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchUserJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:userJoinedMatchHandler
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchCammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:cammentDeletedMatchHandler
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchMembershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:membershipAcceptedMatchHandler
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchUserRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:userRemovedMatchHandler
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchCammentDelivered:(CMServerMessageCammentDeliveredMatchHandler)cammentDeliveredMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:cammentDeliveredMatchHandler
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchAdBanner:(CMServerMessageAdMatchHandler)adMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:adMatchHandler
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchUserGroupStateChanged:(CMServerMessageUserGroupStatusChangedMatchHandler)userGroupStateChangedHadler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:userGroupStateChangedHadler
            videoSyncEvent:^(CMVideoSyncEventMessage *videoSyncEventMessage) {}];
}

- (void)matchVideoSyncEvent:(CMServerMessageVideoSyncEventMatchHandler)videoSyncEventMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
        videoSyncEvent:videoSyncEventMatchHandler];
}

@end
