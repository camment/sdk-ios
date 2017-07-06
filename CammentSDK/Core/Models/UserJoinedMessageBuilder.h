#import <Foundation/Foundation.h>

@class UserJoinedMessage;
@class User;

@interface UserJoinedMessageBuilder : NSObject

+ (instancetype)userJoinedMessage;

+ (instancetype)userJoinedMessageFromExistingUserJoinedMessage:(UserJoinedMessage *)existingUserJoinedMessage;

- (UserJoinedMessage *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withJoinedUser:(User *)joinedUser;

@end

