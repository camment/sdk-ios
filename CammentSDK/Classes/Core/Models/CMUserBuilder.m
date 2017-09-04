#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUser.h"
#import "CMUserBuilder.h"

@implementation CMUserBuilder
{
  NSString *_userId;
  NSString *_cognitoUserId;
  NSString *_fbUserId;
  NSString *_username;
  NSString *_firstname;
  NSString *_lastname;
  NSString *_email;
  NSString *_visibility;
  NSString *_userPhoto;
  CMUserStatus _status;
}

+ (instancetype)user
{
  return [[CMUserBuilder alloc] init];
}

+ (instancetype)userFromExistingUser:(CMUser *)existingUser
{
  return [[[[[[[[[[[CMUserBuilder user]
                   withUserId:existingUser.userId]
                  withCognitoUserId:existingUser.cognitoUserId]
                 withFbUserId:existingUser.fbUserId]
                withUsername:existingUser.username]
               withFirstname:existingUser.firstname]
              withLastname:existingUser.lastname]
             withEmail:existingUser.email]
            withVisibility:existingUser.visibility]
           withUserPhoto:existingUser.userPhoto]
          withStatus:existingUser.status];
}

- (CMUser *)build
{
  return [[CMUser alloc] initWithUserId:_userId cognitoUserId:_cognitoUserId fbUserId:_fbUserId username:_username firstname:_firstname lastname:_lastname email:_email visibility:_visibility userPhoto:_userPhoto status:_status];
}

- (instancetype)withUserId:(NSString *)userId
{
  _userId = [userId copy];
  return self;
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

- (instancetype)withFirstname:(NSString *)firstname
{
  _firstname = [firstname copy];
  return self;
}

- (instancetype)withLastname:(NSString *)lastname
{
  _lastname = [lastname copy];
  return self;
}

- (instancetype)withEmail:(NSString *)email
{
  _email = [email copy];
  return self;
}

- (instancetype)withVisibility:(NSString *)visibility
{
  _visibility = [visibility copy];
  return self;
}

- (instancetype)withUserPhoto:(NSString *)userPhoto
{
  _userPhoto = [userPhoto copy];
  return self;
}

- (instancetype)withStatus:(CMUserStatus)status
{
  _status = status;
  return self;
}

@end

