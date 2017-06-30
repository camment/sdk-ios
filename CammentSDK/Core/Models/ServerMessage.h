/**
 * This file is generated using the remodel generation script.
 * The name of the input file is ServerMessage.adtValue
 */

#import <Foundation/Foundation.h>
#import "Camment.h"
#import "Invitation.h"

typedef void (^ServerMessageInvitationMatchHandler)(Invitation *invitation);
typedef void (^ServerMessageCammentMatchHandler)(Camment *camment);

@interface ServerMessage : NSObject <NSCopying>

+ (instancetype)cammentWithCamment:(Camment *)camment;

+ (instancetype)invitationWithInvitation:(Invitation *)invitation;

- (void)matchInvitation:(ServerMessageInvitationMatchHandler)invitationMatchHandler camment:(ServerMessageCammentMatchHandler)cammentMatchHandler;

@end

