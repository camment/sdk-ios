#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserJoinedMessage.h"
#import "CMUserJoinedMessageBuilder.h"

@implementation CMUserJoinedMessageBuilder
{
  CMUsersGroup *_usersGroup;
  CMUser *_joinedUser;
  CMShow *_show;
}

+ (instancetype)userJoinedMessage
{
  return [[CMUserJoinedMessageBuilder alloc] init];
}

+ (instancetype)userJoinedMessageFromExistingUserJoinedMessage:(CMUserJoinedMessage *)existingUserJoinedMessage
{
  return [[[[CMUserJoinedMessageBuilder userJoinedMessage]
            withUsersGroup:existingUserJoinedMessage.usersGroup]
           withJoinedUser:existingUserJoinedMessage.joinedUser]
          withShow:existingUserJoinedMessage.show];
}

- (CMUserJoinedMessage *)build
{
  return [[CMUserJoinedMessage alloc] initWithUsersGroup:_usersGroup joinedUser:_joinedUser show:_show];
}

- (instancetype)withUsersGroup:(CMUsersGroup *)usersGroup
{
  _usersGroup = [usersGroup copy];
  return self;
}

- (instancetype)withJoinedUser:(CMUser *)joinedUser
{
  _joinedUser = [joinedUser copy];
  return self;
}

- (instancetype)withShow:(CMShow *)show
{
  _show = [show copy];
  return self;
}

@end

