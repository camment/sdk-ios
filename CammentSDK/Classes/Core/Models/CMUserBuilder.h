#import <Foundation/Foundation.h>
#import "CMUserStatus.h"

@class CMUser;

@interface CMUserBuilder : NSObject

+ (instancetype)user;

+ (instancetype)userFromExistingUser:(CMUser *)existingUser;

- (CMUser *)build;

- (instancetype)withUserId:(NSString *)userId;

- (instancetype)withCognitoUserId:(NSString *)cognitoUserId;

- (instancetype)withFbUserId:(NSString *)fbUserId;

- (instancetype)withUsername:(NSString *)username;

- (instancetype)withFirstname:(NSString *)firstname;

- (instancetype)withLastname:(NSString *)lastname;

- (instancetype)withEmail:(NSString *)email;

- (instancetype)withVisibility:(NSString *)visibility;

- (instancetype)withUserPhoto:(NSString *)userPhoto;

- (instancetype)withStatus:(CMUserStatus)status;

@end

