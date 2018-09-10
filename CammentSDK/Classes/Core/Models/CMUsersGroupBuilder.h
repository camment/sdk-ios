#import <Foundation/Foundation.h>

@class CMUsersGroup;
@class CMUser;

@interface CMUsersGroupBuilder : NSObject

+ (instancetype)usersGroup;

+ (instancetype)usersGroupFromExistingUsersGroup:(CMUsersGroup *)existingUsersGroup;

- (CMUsersGroup *)build;

- (instancetype)withUuid:(NSString *)uuid;

- (instancetype)withShowUuid:(NSString *)showUuid;

- (instancetype)withOwnerCognitoUserId:(NSString *)ownerCognitoUserId;

- (instancetype)withHostCognitoUserId:(NSString *)hostCognitoUserId;

- (instancetype)withTimestamp:(NSString *)timestamp;

- (instancetype)withInvitationLink:(NSString *)invitationLink;

- (instancetype)withUsers:(NSArray<CMUser *> *)users;

- (instancetype)withIsPublic:(BOOL)isPublic;

@end

