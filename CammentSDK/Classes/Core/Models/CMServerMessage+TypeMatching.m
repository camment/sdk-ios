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
                       ad:^(CMAdBanner *adBanner) {}];
}

- (void)matchUserJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:userJoinedMatchHandler
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                       ad:^(CMAdBanner *adBanner) {}];
}

- (void)matchCammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:cammentDeletedMatchHandler
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                       ad:^(CMAdBanner *adBanner) {}];
}

- (void)matchMembershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
       membershipAccepted:membershipAcceptedMatchHandler
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                       ad:^(CMAdBanner *adBanner) {}];
}

- (void)matchUserRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:userRemovedMatchHandler
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:^(CMAdBanner *adBanner) {}];
}

- (void)matchCammentDelivered:(CMServerMessageCammentDeliveredMatchHandler)cammentDeliveredMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:cammentDeliveredMatchHandler
                    ad:^(CMAdBanner *adBanner) {}];
}

- (void)matchAdBanner:(CMServerMessageAdMatchHandler)adMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}
                    ad:adMatchHandler];
}

@end
