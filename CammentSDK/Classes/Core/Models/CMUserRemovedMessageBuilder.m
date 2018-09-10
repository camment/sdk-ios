#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserRemovedMessage.h"
#import "CMUserRemovedMessageBuilder.h"

@implementation CMUserRemovedMessageBuilder
{
  NSString *_userGroupUuid;
  CMUser *_user;
}

+ (instancetype)userRemovedMessage
{
  return [[CMUserRemovedMessageBuilder alloc] init];
}

+ (instancetype)userRemovedMessageFromExistingUserRemovedMessage:(CMUserRemovedMessage *)existingUserRemovedMessage
{
  return [[[CMUserRemovedMessageBuilder userRemovedMessage]
           withUserGroupUuid:existingUserRemovedMessage.userGroupUuid]
          withUser:existingUserRemovedMessage.user];
}

- (CMUserRemovedMessage *)build
{
  return [[CMUserRemovedMessage alloc] initWithUserGroupUuid:_userGroupUuid user:_user];
}

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid
{
  _userGroupUuid = [userGroupUuid copy];
  return self;
}

- (instancetype)withUser:(CMUser *)user
{
  _user = [user copy];
  return self;
}

@end

