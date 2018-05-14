#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUser.h"
#import "CMUserBuilder.h"

@implementation CMUserBuilder
{
  NSString *_cognitoUserId;
  NSString *_fbUserId;
  NSString *_username;
  NSString *_email;
  NSString *_userPhoto;
  NSString *_blockStatus;
  NSString *_onlineStatus;
}

+ (instancetype)user
{
  return [[CMUserBuilder alloc] init];
}

+ (instancetype)userFromExistingUser:(CMUser *)existingUser
{
  return [[[[[[[[CMUserBuilder user]
                withCognitoUserId:existingUser.cognitoUserId]
               withFbUserId:existingUser.fbUserId]
              withUsername:existingUser.username]
             withEmail:existingUser.email]
            withUserPhoto:existingUser.userPhoto]
           withBlockStatus:existingUser.blockStatus]
          withOnlineStatus:existingUser.onlineStatus];
}

- (CMUser *)build
{
  return [[CMUser alloc] initWithCognitoUserId:_cognitoUserId fbUserId:_fbUserId username:_username email:_email userPhoto:_userPhoto blockStatus:_blockStatus onlineStatus:_onlineStatus];
}

- (instancetype)withCognitoUserId:(NSString *)cognitoUserId
{
  _cognitoUserId = [cognitoUserId copy];
  return self;
}

- (instancetype)withFbUserId:(NSString *)fbUserId
{
  _fbUserId = [fbUserId copy];
  return self;
}

- (instancetype)withUsername:(NSString *)username
{
  _username = [username copy];
  return self;
}

- (instancetype)withEmail:(NSString *)email
{
  _email = [email copy];
  return self;
}

- (instancetype)withUserPhoto:(NSString *)userPhoto
{
  _userPhoto = [userPhoto copy];
  return self;
}

- (instancetype)withBlockStatus:(NSString *)blockStatus
{
  _blockStatus = [blockStatus copy];
  return self;
}

- (instancetype)withOnlineStatus:(NSString *)onlineStatus
{
  _onlineStatus = [onlineStatus copy];
  return self;
}

@end

