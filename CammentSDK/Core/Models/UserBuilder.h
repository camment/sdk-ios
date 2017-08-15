#import <Foundation/Foundation.h>
#import "CMUserStatus.h"

@class User;

@interface UserBuilder : NSObject

+ (instancetype)user;

+ (instancetype)userFromExistingUser:(User *)existingUser;

- (User *)build;

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

