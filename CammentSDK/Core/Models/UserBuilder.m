#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "User.h"
#import "UserBuilder.h"

@implementation UserBuilder
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
}

+ (instancetype)user
{
  return [[UserBuilder alloc] init];
}

+ (instancetype)userFromExistingUser:(User *)existingUser
{
  return [[[[[[[[[[UserBuilder user]
                  withUserId:existingUser.userId]
                 withCognitoUserId:existingUser.cognitoUserId]
                withFbUserId:existingUser.fbUserId]
               withUsername:existingUser.username]
              withFirstname:existingUser.firstname]
             withLastname:existingUser.lastname]
            withEmail:existingUser.email]
           withVisibility:existingUser.visibility]
          withUserPhoto:existingUser.userPhoto];
}

- (User *)build
{
  return [[User alloc] initWithUserId:_userId cognitoUserId:_cognitoUserId fbUserId:_fbUserId username:_username firstname:_firstname lastname:_lastname email:_email visibility:_visibility userPhoto:_userPhoto];
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

@end

