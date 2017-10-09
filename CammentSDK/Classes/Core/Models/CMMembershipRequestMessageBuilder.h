#import <Foundation/Foundation.h>

@class CMMembershipRequestMessage;
@class CMUser;
@class CMUsersGroup;
@class CMShow;

@interface CMMembershipRequestMessageBuilder : NSObject

+ (instancetype)membershipRequestMessage;

+ (instancetype)membershipRequestMessageFromExistingMembershipRequestMessage:(CMMembershipRequestMessage *)existingMembershipRequestMessage;

- (CMMembershipRequestMessage *)build;

- (instancetype)withJoiningUser:(CMUser *)joiningUser;

- (instancetype)withGroup:(CMUsersGroup *)group;

- (instancetype)withShow:(CMShow *)show;

@end

