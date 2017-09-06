#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMMembershipAcceptedMessage.h"
#import "CMMembershipAcceptedMessageBuilder.h"

@implementation CMMembershipAcceptedMessageBuilder
{
  CMUsersGroup *_group;
}

+ (instancetype)membershipAcceptedMessage
{
  return [[CMMembershipAcceptedMessageBuilder alloc] init];
}

+ (instancetype)membershipAcceptedMessageFromExistingMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)existingMembershipAcceptedMessage
{
  return [[CMMembershipAcceptedMessageBuilder membershipAcceptedMessage]
          withGroup:existingMembershipAcceptedMessage.group];
}

- (CMMembershipAcceptedMessage *)build
{
  return [[CMMembershipAcceptedMessage alloc] initWithGroup:_group];
}

- (instancetype)withGroup:(CMUsersGroup *)group
{
  _group = [group copy];
  return self;
}

@end

