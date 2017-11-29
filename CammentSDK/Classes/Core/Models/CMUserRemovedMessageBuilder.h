#import <Foundation/Foundation.h>

@class CMUserRemovedMessage;
@class CMUser;

@interface CMUserRemovedMessageBuilder : NSObject

+ (instancetype)userRemovedMessage;

+ (instancetype)userRemovedMessageFromExistingUserRemovedMessage:(CMUserRemovedMessage *)existingUserRemovedMessage;

- (CMUserRemovedMessage *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withRemovedUser:(CMUser *)removedUser;

@end

