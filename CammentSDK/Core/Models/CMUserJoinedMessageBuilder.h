#import <Foundation/Foundation.h>

@class CMUserJoinedMessage;
@class CMUser;

@interface CMUserJoinedMessageBuilder : NSObject

+ (instancetype)userJoinedMessage;

+ (instancetype)userJoinedMessageFromExistingUserJoinedMessage:(CMUserJoinedMessage *)existingUserJoinedMessage;

- (CMUserJoinedMessage *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withJoinedUser:(CMUser *)joinedUser;

@end

