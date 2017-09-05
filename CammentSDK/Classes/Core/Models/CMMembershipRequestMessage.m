/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMMembershipRequestMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMMembershipRequestMessage.h"

@implementation CMMembershipRequestMessage

- (instancetype)initWithJoiningUser:(CMUser *)joiningUser group:(CMUsersGroup *)group
{
  if ((self = [super init])) {
    _joiningUser = [joiningUser copy];
    _group = [group copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t joiningUser: %@; \n\t group: %@; \n", [super description], _joiningUser, _group];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_joiningUser hash], [_group hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 2; ++ii) {
    unsigned long long base = (((unsigned long long)result) << 32 | subhashes[ii]);
    base = (~base) + (base << 18);
    base ^= (base >> 31);
    base *=  21;
    base ^= (base >> 11);
    base += (base << 6);
    base ^= (base >> 22);
    result = base;
  }
  return result;
}

- (BOOL)isEqual:(CMMembershipRequestMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_joiningUser == object->_joiningUser ? YES : [_joiningUser isEqual:object->_joiningUser]) &&
    (_group == object->_group ? YES : [_group isEqual:object->_group]);
}

@end

