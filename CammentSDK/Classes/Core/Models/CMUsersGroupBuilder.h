#import <Foundation/Foundation.h>

@class CMUsersGroup;

@interface CMUsersGroupBuilder : NSObject

+ (instancetype)usersGroup;

+ (instancetype)usersGroupFromExistingUsersGroup:(CMUsersGroup *)existingUsersGroup;

- (CMUsersGroup *)build;

- (instancetype)withUuid:(NSString *)uuid;

- (instancetype)withOwnerCognitoUserId:(NSString *)ownerCognitoUserId;

- (instancetype)withHostCognitoUserId:(NSString *)hostCognitoUserId;

- (instancetype)withTimestamp:(NSString *)timestamp;

- (instancetype)withInvitationLink:(NSString *)invitationLink;

@end

