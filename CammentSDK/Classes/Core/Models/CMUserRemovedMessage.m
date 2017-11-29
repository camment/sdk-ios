/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserRemovedMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserRemovedMessage.h"

@implementation CMUserRemovedMessage

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid removedUser:(CMUser *)removedUser
{
  if ((self = [super init])) {
    _userGroupUuid = [userGroupUuid copy];
    _removedUser = [removedUser copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userGroupUuid: %@; \n\t removedUser: %@; \n", [super description], _userGroupUuid, _removedUser];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_userGroupUuid hash], [_removedUser hash]};
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

- (BOOL)isEqual:(CMUserRemovedMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_userGroupUuid == object->_userGroupUuid ? YES : [_userGroupUuid isEqual:object->_userGroupUuid]) &&
    (_removedUser == object->_removedUser ? YES : [_removedUser isEqual:object->_removedUser]);
}

@end

