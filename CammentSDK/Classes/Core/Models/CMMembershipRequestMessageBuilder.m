#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMMembershipRequestMessage.h"
#import "CMMembershipRequestMessageBuilder.h"

@implementation CMMembershipRequestMessageBuilder
{
  CMUser *_joiningUser;
  CMUsersGroup *_group;
  CMShow *_show;
}

+ (instancetype)membershipRequestMessage
{
  return [[CMMembershipRequestMessageBuilder alloc] init];
}

+ (instancetype)membershipRequestMessageFromExistingMembershipRequestMessage:(CMMembershipRequestMessage *)existingMembershipRequestMessage
{
  return [[[[CMMembershipRequestMessageBuilder membershipRequestMessage]
            withJoiningUser:existingMembershipRequestMessage.joiningUser]
           withGroup:existingMembershipRequestMessage.group]
          withShow:existingMembershipRequestMessage.show];
}

- (CMMembershipRequestMessage *)build
{
  return [[CMMembershipRequestMessage alloc] initWithJoiningUser:_joiningUser group:_group show:_show];
}

- (instancetype)withJoiningUser:(CMUser *)joiningUser
{
  _joiningUser = [joiningUser copy];
  return self;
}

- (instancetype)withGroup:(CMUsersGroup *)group
{
  _group = [group copy];
  return self;
}

- (instancetype)withShow:(CMShow *)show
{
  _show = [show copy];
  return self;
}

@end

