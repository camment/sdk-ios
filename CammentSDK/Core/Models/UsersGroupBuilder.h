#import <Foundation/Foundation.h>

@class UsersGroup;

@interface UsersGroupBuilder : NSObject

+ (instancetype)usersGroup;

+ (instancetype)usersGroupFromExistingUsersGroup:(UsersGroup *)existingUsersGroup;

- (UsersGroup *)build;

- (instancetype)withUuid:(NSString *)uuid;

- (instancetype)withOwnerCognitoUserId:(NSString *)ownerCognitoUserId;

- (instancetype)withTimestamp:(NSString *)timestamp;

@end

