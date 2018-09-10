#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMMembershipAcceptedMessage.h"
#import "CMMembershipAcceptedMessageBuilder.h"

@implementation CMMembershipAcceptedMessageBuilder
{
  CMUsersGroup *_group;
  CMShow *_show;
}

+ (instancetype)membershipAcceptedMessage
{
  return [[CMMembershipAcceptedMessageBuilder alloc] init];
}

+ (instancetype)membershipAcceptedMessageFromExistingMembershipAcceptedMessage:(CMMembershipAcceptedMessage *)existingMembershipAcceptedMessage
{
  return [[[CMMembershipAcceptedMessageBuilder membershipAcceptedMessage]
           withGroup:existingMembershipAcceptedMessage.group]
          withShow:existingMembershipAcceptedMessage.show];
}

- (CMMembershipAcceptedMessage *)build
{
  return [[CMMembershipAcceptedMessage alloc] initWithGroup:_group show:_show];
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

