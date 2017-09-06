//
// Created by Alexander Fedosov on 05.09.17.
//

#import "CMServerMessage+TypeMatching.h"


@implementation CMServerMessage (TypeMatching)

- (void)matchInvitation:(CMServerMessageInvitationMatchHandler)invitationMatchHandler {
    [self matchInvitation:invitationMatchHandler
                  camment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}];
}

- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler {
    [self matchInvitation:^(CMInvitation *invitation) {}
                  camment:cammentMatchHandler
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}];
}

- (void)matchUserJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler {
    [self matchInvitation:^(CMInvitation *invitation) {}
                  camment:^(CMCamment *camment) {}
               userJoined:userJoinedMatchHandler
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}];
}

- (void)matchCammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler {
    [self matchInvitation:^(CMInvitation *invitation) {}
                  camment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:cammentDeletedMatchHandler
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}];
}

- (void)matchMembershipRequest:(CMServerMessageMembershipRequestMatchHandler)membershipRequestMatchHandler {
    [self matchInvitation:^(CMInvitation *invitation) {}
                  camment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:membershipRequestMatchHandler
       membershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {}];
}

- (void)matchMembershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler {
    [self matchInvitation:^(CMInvitation *invitation) {}
                  camment:^(CMCamment *camment) {}
               userJoined:^(CMUserJoinedMessage *userJoinedMessage) {}
           cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {}
        membershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {}
       membershipAccepted:membershipAcceptedMatchHandler];
}

@end