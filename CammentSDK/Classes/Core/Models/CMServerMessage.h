/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMServerMessage.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMCamment.h"
#import "CMUserJoinedMessage.h"
#import "CMCammentDeletedMessage.h"
#import "CMCammentDeliveredMessage.h"
#import "CMMembershipAcceptedMessage.h"
#import "CMUserRemovedMessage.h"
#import "CMAdBanner.h"
#import "CMUserGroupStatusChangedMessage.h"

typedef void (^CMServerMessageCammentMatchHandler)(CMCamment *camment);
typedef void (^CMServerMessageUserJoinedMatchHandler)(CMUserJoinedMessage *userJoinedMessage);
typedef void (^CMServerMessageCammentDeletedMatchHandler)(CMCammentDeletedMessage *cammentDeletedMessage);
typedef void (^CMServerMessageMembershipAcceptedMatchHandler)(CMMembershipAcceptedMessage *membershipAcceptedMessage);
typedef void (^CMServerMessageUserRemovedMatchHandler)(CMUserRemovedMessage *userRemovedMessage);
typedef void (^CMServerMessageCammentDeliveredMatchHandler)(CMCammentDeliveredMessage *cammentDelivered);
typedef void (^CMServerMessageAdMatchHandler)(CMAdBanner *adBanner);
typedef void (^CMServerMessageUserGroupStatusChangedMatchHandler)(CMUserGroupStatusChangedMessage *userGroupStatusChangedMessage);

@interface CMServerMessage : NSObject <NSCopying>

+ (instancetype)adWithAdBanner:(CMAdBanner *)adBanner;

+ (instancetype)cammentDeletedWithCammentDeletedMessage:(CMCammentDeletedMessage *)cammentDeletedMessage;

+ (instancetype)cammentDeliveredWithCammentDelivered:(CMCammentDeliveredMessage *)cammentDelivered;

+ (instancetype)cammentWithCamment:(CMCamment *)camment;

+ (instancetype)membershipAcceptedWithMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)membershipAcceptedMessage;

+ (instancetype)userGroupStatusChangedWithUserGroupStatusChangedMessage:(CMUserGroupStatusChangedMessage *)userGroupStatusChangedMessage;

+ (instancetype)userJoinedWithUserJoinedMessage:(CMUserJoinedMessage *)userJoinedMessage;

+ (instancetype)userRemovedWithUserRemovedMessage:(CMUserRemovedMessage *)userRemovedMessage;

- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler userJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler cammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler membershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler userRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler cammentDelivered:(CMServerMessageCammentDeliveredMatchHandler)cammentDeliveredMatchHandler ad:(CMServerMessageAdMatchHandler)adMatchHandler userGroupStatusChanged:(CMServerMessageUserGroupStatusChangedMatchHandler)userGroupStatusChangedMatchHandler;

@end

