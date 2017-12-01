/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserJoinedMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserJoinedMessage.h"

@implementation CMUserJoinedMessage

- (instancetype)initWithUsersGroup:(CMUsersGroup *)usersGroup joinedUser:(CMUser *)joinedUser show:(CMShow *)show
{
  if ((self = [super init])) {
    _usersGroup = [usersGroup copy];
    _joinedUser = [joinedUser copy];
    _show = [show copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t usersGroup: %@; \n\t joinedUser: %@; \n\t show: %@; \n", [super description], _usersGroup, _joinedUser, _show];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_usersGroup hash], [_joinedUser hash], [_show hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 3; ++ii) {
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

- (BOOL)isEqual:(CMUserJoinedMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_usersGroup == object->_usersGroup ? YES : [_usersGroup isEqual:object->_usersGroup]) &&
    (_joinedUser == object->_joinedUser ? YES : [_joinedUser isEqual:object->_joinedUser]) &&
    (_show == object->_show ? YES : [_show isEqual:object->_show]);
}

@end

