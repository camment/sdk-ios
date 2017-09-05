//
// Created by Alexander Fedosov on 05.09.17.
//

#import <Foundation/Foundation.h>
#import "CMServerMessage.h"

@interface CMServerMessage (TypeMatching)

- (void)matchInvitation:(CMServerMessageInvitationMatchHandler)invitationMatchHandler;
- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler;
- (void)matchUserJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler;
- (void)matchCammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler;
- (void)matchMembershipRequest:(CMServerMessageMembershipRequestMatchHandler)membershipRequestMatchHandler;

@end