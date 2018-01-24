#import <Foundation/Foundation.h>

@class CMUser;

@interface CMUserBuilder : NSObject

+ (instancetype)user;

+ (instancetype)userFromExistingUser:(CMUser *)existingUser;

- (CMUser *)build;

- (instancetype)withCognitoUserId:(NSString *)cognitoUserId;

- (instancetype)withFbUserId:(NSString *)fbUserId;

- (instancetype)withUsername:(NSString *)username;

- (instancetype)withEmail:(NSString *)email;

- (instancetype)withUserPhoto:(NSString *)userPhoto;

- (instancetype)withState:(NSString *)state;

@end

