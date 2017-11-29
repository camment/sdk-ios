/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMServerMessage.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMCamment.h"
#import "CMUserJoinedMessage.h"
#import "CMCammentDeletedMessage.h"
#import "CMMembershipRequestMessage.h"
#import "CMMembershipAcceptedMessage.h"
#import "CMUserRemovedMessage.h"

typedef void (^CMServerMessageCammentMatchHandler)(CMCamment *camment);
typedef void (^CMServerMessageUserJoinedMatchHandler)(CMUserJoinedMessage *userJoinedMessage);
typedef void (^CMServerMessageCammentDeletedMatchHandler)(CMCammentDeletedMessage *cammentDeletedMessage);
typedef void (^CMServerMessageMembershipRequestMatchHandler)(CMMembershipRequestMessage *membershipRequestMessage);
typedef void (^CMServerMessageMembershipAcceptedMatchHandler)(CMMembershipAcceptedMessage *membershipAcceptedMessage);
typedef void (^CMServerMessageUserRemovedMatchHandler)(CMUserRemovedMessage *userRemovedMessage);

@interface CMServerMessage : NSObject <NSCopying>

+ (instancetype)cammentDeletedWithCammentDeletedMessage:(CMCammentDeletedMessage *)cammentDeletedMessage;

+ (instancetype)cammentWithCamment:(CMCamment *)camment;

+ (instancetype)membershipAcceptedWithMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)membershipAcceptedMessage;

+ (instancetype)membershipRequestWithMembershipRequestMessage:(CMMembershipRequestMessage *)membershipRequestMessage;

+ (instancetype)userJoinedWithUserJoinedMessage:(CMUserJoinedMessage *)userJoinedMessage;

+ (instancetype)userRemovedWithUserRemovedMessage:(CMUserRemovedMessage *)userRemovedMessage;

- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler userJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler cammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler membershipRequest:(CMServerMessageMembershipRequestMatchHandler)membershipRequestMatchHandler membershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler userRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler;

@end

