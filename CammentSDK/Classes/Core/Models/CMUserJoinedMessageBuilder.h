#import <Foundation/Foundation.h>

@class CMUserJoinedMessage;
@class CMUser;
@class CMUsersGroup;
@class CMShow;

@interface CMUserJoinedMessageBuilder : NSObject

+ (instancetype)userJoinedMessage;

+ (instancetype)userJoinedMessageFromExistingUserJoinedMessage:(CMUserJoinedMessage *)existingUserJoinedMessage;

- (CMUserJoinedMessage *)build;

- (instancetype)withUsersGroup:(CMUsersGroup *)usersGroup;

- (instancetype)withJoinedUser:(CMUser *)joinedUser;

- (instancetype)withShow:(CMShow *)show;

@end

