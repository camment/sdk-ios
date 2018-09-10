#import <Foundation/Foundation.h>

@class CMUserGroupStatusChangedMessage;
@class CMUser;

@interface CMUserGroupStatusChangedMessageBuilder : NSObject

+ (instancetype)userGroupStatusChangedMessage;

+ (instancetype)userGroupStatusChangedMessageFromExistingUserGroupStatusChangedMessage:(CMUserGroupStatusChangedMessage *)existingUserGroupStatusChangedMessage;

- (CMUserGroupStatusChangedMessage *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withUser:(CMUser *)user;

- (instancetype)withState:(NSString *)state;

@end

