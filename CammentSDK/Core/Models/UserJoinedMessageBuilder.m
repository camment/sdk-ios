#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "UserJoinedMessage.h"
#import "UserJoinedMessageBuilder.h"

@implementation UserJoinedMessageBuilder
{
  NSString *_userGroupUuid;
  User *_joinedUser;
}

+ (instancetype)userJoinedMessage
{
  return [[UserJoinedMessageBuilder alloc] init];
}

+ (instancetype)userJoinedMessageFromExistingUserJoinedMessage:(UserJoinedMessage *)existingUserJoinedMessage
{
  return [[[UserJoinedMessageBuilder userJoinedMessage]
           withUserGroupUuid:existingUserJoinedMessage.userGroupUuid]
          withJoinedUser:existingUserJoinedMessage.joinedUser];
}

- (UserJoinedMessage *)build
{
  return [[UserJoinedMessage alloc] initWithUserGroupUuid:_userGroupUuid joinedUser:_joinedUser];
}

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid
{
  _userGroupUuid = [userGroupUuid copy];
  return self;
}

- (instancetype)withJoinedUser:(User *)joinedUser
{
  _joinedUser = [joinedUser copy];
  return self;
}

@end

