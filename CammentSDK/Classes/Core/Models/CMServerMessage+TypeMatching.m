//
// Created by Alexander Fedosov on 05.09.17.
//

#import "CMServerMessage+TypeMatching.h"


@implementation CMServerMessage (TypeMatching)


- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler {
    [self matchCamment:cammentMatchHandler
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}];
}

- (void)matchUserJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:userJoinedMatchHandler
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}];
}

- (void)matchCammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:cammentDeletedMatchHandler
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}];
}

- (void)matchMembershipRequest:(CMServerMessageMembershipRequestMatchHandler)membershipRequestMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:membershipRequestMatchHandler
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
              userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
         cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}];
}

- (void)matchMembershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:membershipAcceptedMatchHandler
            userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}];
}

- (void)matchUserRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
     membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:userRemovedMatchHandler
      cammentDelivered:^(CMCammentDeliveredMessage *cammentDeliveredMessage) {}];
}

- (void)matchCammentDelivered:(CMServerMessageCammentDeliveredMatchHandler)cammentDeliveredMatchHandler {
    [self matchCamment:^(CMCamment *camment) {}
            userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
        cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
     membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
    membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}
           userRemoved:^(CMUserRemovedMessage *userRemovedMessage) {}
      cammentDelivered:cammentDeliveredMatchHandler];
}

@end