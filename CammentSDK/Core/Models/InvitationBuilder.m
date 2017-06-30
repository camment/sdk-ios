#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Invitation.h"
#import "InvitationBuilder.h"

@implementation InvitationBuilder
{
  NSString *_userGroupUuid;
  NSString *_userCognitoUuid;
}

+ (instancetype)invitation
{
  return [[InvitationBuilder alloc] init];
}

+ (instancetype)invitationFromExistingInvitation:(Invitation *)existingInvitation
{
  return [[[InvitationBuilder invitation]
           withUserGroupUuid:existingInvitation.userGroupUuid]
          withUserCognitoUuid:existingInvitation.userCognitoUuid];
}

- (Invitation *)build
{
  return [[Invitation alloc] initWithUserGroupUuid:_userGroupUuid userCognitoUuid:_userCognitoUuid];
}

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid
{
  _userGroupUuid = [userGroupUuid copy];
  return self;
}

- (instancetype)withUserCognitoUuid:(NSString *)userCognitoUuid
{
  _userCognitoUuid = [userCognitoUuid copy];
  return self;
}

@end

