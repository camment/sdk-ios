#import <Foundation/Foundation.h>

@class CMMembershipAcceptedMessage;
@class CMUsersGroup;

@interface CMMembershipAcceptedMessageBuilder : NSObject

+ (instancetype)membershipAcceptedMessage;

+ (instancetype)membershipAcceptedMessageFromExistingMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)existingMembershipAcceptedMessage;

- (CMMembershipAcceptedMessage *)build;

- (instancetype)withGroup:(CMUsersGroup *)group;

@end

