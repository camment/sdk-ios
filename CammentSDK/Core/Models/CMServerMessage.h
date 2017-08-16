/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMServerMessage.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMCamment.h"
#import "CMInvitation.h"
#import "CMUserJoinedMessage.h"
#import "CMCammentDeletedMessage.h"

typedef void (^CMServerMessageInvitationMatchHandler)(CMInvitation *invitation);
typedef void (^CMServerMessageCammentMatchHandler)(CMCamment *camment);
typedef void (^CMServerMessageUserJoinedMatchHandler)(CMUserJoinedMessage *userJoinedMessage);
typedef void (^CMServerMessageCammentDeletedMatchHandler)(CMCammentDeletedMessage *cammentDeletedMessage);

@interface CMServerMessage : NSObject <NSCopying>

+ (instancetype)cammentDeletedWithCammentDeletedMessage:(CMCammentDeletedMessage *)cammentDeletedMessage;

+ (instancetype)cammentWithCamment:(CMCamment *)camment;

+ (instancetype)invitationWithInvitation:(CMInvitation *)invitation;

+ (instancetype)userJoinedWithUserJoinedMessage:(CMUserJoinedMessage *)userJoinedMessage;

- (void)matchInvitation:(CMServerMessageInvitationMatchHandler)invitationMatchHandler camment:(CMServerMessageCammentMatchHandler)cammentMatchHandler userJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler cammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler;

@end

