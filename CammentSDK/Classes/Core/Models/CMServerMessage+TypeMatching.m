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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
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
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
}

- (void)matchPlayerStateEvent:(CMServerMessagePlayerStateMatchHandler)playerStateHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
           playerState:playerStateHandler
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
}

- (void)matchNeededPlayerState:(CMServerMessageNeededPlayerStateMatchHandler)neededPlayerStateMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:neededPlayerStateMatchHandler
          newGroupHost:^(CMNewGroupHostMessage *newGroupHostMessage) {}];
}

- (void)matchNewGroupHost:(CMServerMessageNewGroupHostMatchHandler)newGroupHostHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}
userGroupStatusChanged:^(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage) {}
           playerState:^(CMNewPlayerStateMessage *newPlayerStateMessage) {}
     neededPlayerState:^(CMNeededPlayerStateMessage * neededPlayerStateMessage) {}
          newGroupHost:newGroupHostHandler];
}

@end
