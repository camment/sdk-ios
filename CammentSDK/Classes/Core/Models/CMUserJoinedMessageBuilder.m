#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserJoinedMessage.h"
#import "CMUserJoinedMessageBuilder.h"

@implementation CMUserJoinedMessageBuilder
{
  NSString *_userGroupUuid;
  CMUser *_joinedUser;
}

+ (instancetype)userJoinedMessage
{
  return [[CMUserJoinedMessageBuilder alloc] init];
}

+ (instancetype)userJoinedMessageFromExistingUserJoinedMessage:(CMUserJoinedMessage *)existingUserJoinedMessage
{
  return [[[CMUserJoinedMessageBuilder userJoinedMessage]
           withUserGroupUuid:existingUserJoinedMessage.userGroupUuid]
          withJoinedUser:existingUserJoinedMessage.joinedUser];
}

- (CMUserJoinedMessage *)build
{
  return [[CMUserJoinedMessage alloc] initWithUserGroupUuid:_userGroupUuid joinedUser:_joinedUser];
}

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid
{
  _userGroupUuid = [userGroupUuid copy];
  return self;
}

- (instancetype)withJoinedUser:(CMUser *)joinedUser
{
  _joinedUser = [joinedUser copy];
  return self;
}

@end

