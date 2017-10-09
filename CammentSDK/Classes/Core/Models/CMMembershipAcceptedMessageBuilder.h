#import <Foundation/Foundation.h>

@class CMMembershipAcceptedMessage;
@class CMUsersGroup;
@class CMShow;

@interface CMMembershipAcceptedMessageBuilder : NSObject

+ (instancetype)membershipAcceptedMessage;

+ (instancetype)membershipAcceptedMessageFromExistingMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)existingMembershipAcceptedMessage;

- (CMMembershipAcceptedMessage *)build;

- (instancetype)withGroup:(CMUsersGroup *)group;

- (instancetype)withShow:(CMShow *)show;

@end

