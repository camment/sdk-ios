#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserGroupStatusChangedMessage.h"
#import "CMUserGroupStatusChangedMessageBuilder.h"

@implementation CMUserGroupStatusChangedMessageBuilder
{
  NSString *_userGroupUuid;
  CMUser *_user;
  NSString *_state;
}

+ (instancetype)userGroupStatusChangedMessage
{
  return [[CMUserGroupStatusChangedMessageBuilder alloc] init];
}

+ (instancetype)userGroupStatusChangedMessageFromExistingUserGroupStatusChangedMessage:(CMUserGroupStatusChangedMessage *)existingUserGroupStatusChangedMessage
{
  return [[[[CMUserGroupStatusChangedMessageBuilder userGroupStatusChangedMessage]
            withUserGroupUuid:existingUserGroupStatusChangedMessage.userGroupUuid]
           withUser:existingUserGroupStatusChangedMessage.user]
          withState:existingUserGroupStatusChangedMessage.state];
}

- (CMUserGroupStatusChangedMessage *)build
{
  return [[CMUserGroupStatusChangedMessage alloc] initWithUserGroupUuid:_userGroupUuid user:_user state:_state];
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

- (instancetype)withState:(NSString *)state
{
  _state = [state copy];
  return self;
}

@end

