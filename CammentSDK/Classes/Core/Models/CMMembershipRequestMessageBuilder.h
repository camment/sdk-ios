#import <Foundation/Foundation.h>

@class CMMembershipRequestMessage;
@class CMUser;
@class CMUsersGroup;

@interface CMMembershipRequestMessageBuilder : NSObject

+ (instancetype)membershipRequestMessage;

+ (instancetype)membershipRequestMessageFromExistingMembershipRequestMessage:(CMMembershipRequestMessage *)existingMembershipRequestMessage;

- (CMMembershipRequestMessage *)build;

- (instancetype)withJoiningUser:(CMUser *)joiningUser;

- (instancetype)withGroup:(CMUsersGroup *)group;

@end

