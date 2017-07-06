/**
 * This file is generated using the remodel generation script.
 * The name of the input file is ServerMessage.adtValue
 */

#import <Foundation/Foundation.h>
#import "Camment.h"
#import "Invitation.h"
#import "UserJoinedMessage.h"
#import "CammentDeletedMessage.h"

typedef void (^ServerMessageInvitationMatchHandler)(Invitation *invitation);
typedef void (^ServerMessageCammentMatchHandler)(Camment *camment);
typedef void (^ServerMessageUserJoinedMatchHandler)(UserJoinedMessage *userJoinedMessage);
typedef void (^ServerMessageCammentDeletedMatchHandler)(CammentDeletedMessage *cammentDeletedMessage);

@interface ServerMessage : NSObject <NSCopying>

+ (instancetype)cammentDeletedWithCammentDeletedMessage:(CammentDeletedMessage *)cammentDeletedMessage;

+ (instancetype)cammentWithCamment:(Camment *)camment;

+ (instancetype)invitationWithInvitation:(Invitation *)invitation;

+ (instancetype)userJoinedWithUserJoinedMessage:(UserJoinedMessage *)userJoinedMessage;

- (void)matchInvitation:(ServerMessageInvitationMatchHandler)invitationMatchHandler camment:(ServerMessageCammentMatchHandler)cammentMatchHandler userJoined:(ServerMessageUserJoinedMatchHandler)userJoinedMatchHandler cammentDeleted:(ServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler;

@end

