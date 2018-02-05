/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserGroupStatusChangedMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserGroupStatusChangedMessage.h"

@implementation CMUserGroupStatusChangedMessage

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid user:(CMUser *)user state:(NSString *)state
{
  if ((self = [super init])) {
    _userGroupUuid = [userGroupUuid copy];
    _user = [user copy];
    _state = [state copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userGroupUuid: %@; \n\t user: %@; \n\t state: %@; \n", [super description], _userGroupUuid, _user, _state];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_userGroupUuid hash], [_user hash], [_state hash]};
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

- (BOOL)isEqual:(CMUserGroupStatusChangedMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_userGroupUuid == object->_userGroupUuid ? YES : [_userGroupUuid isEqual:object->_userGroupUuid]) &&
    (_user == object->_user ? YES : [_user isEqual:object->_user]) &&
    (_state == object->_state ? YES : [_state isEqual:object->_state]);
}

@end

