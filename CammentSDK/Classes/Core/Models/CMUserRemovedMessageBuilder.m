#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserRemovedMessage.h"
#import "CMUserRemovedMessageBuilder.h"

@implementation CMUserRemovedMessageBuilder
{
  NSString *_userGroupUuid;
  CMUser *_removedUser;
}

+ (instancetype)userRemovedMessage
{
  return [[CMUserRemovedMessageBuilder alloc] init];
}

+ (instancetype)userRemovedMessageFromExistingUserRemovedMessage:(CMUserRemovedMessage *)existingUserRemovedMessage
{
  return [[[CMUserRemovedMessageBuilder userRemovedMessage]
           withUserGroupUuid:existingUserRemovedMessage.userGroupUuid]
          withRemovedUser:existingUserRemovedMessage.removedUser];
}

- (CMUserRemovedMessage *)build
{
  return [[CMUserRemovedMessage alloc] initWithUserGroupUuid:_userGroupUuid removedUser:_removedUser];
}

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid
{
  _userGroupUuid = [userGroupUuid copy];
  return self;
}

- (instancetype)withRemovedUser:(CMUser *)removedUser
{
  _removedUser = [removedUser copy];
  return self;
}

@end

