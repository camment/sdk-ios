/**
 * This file is generated using the remodel generation script.
 * The name of the input file is UserJoinedMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "UserJoinedMessage.h"

@implementation UserJoinedMessage

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid joinedUser:(User *)joinedUser
{
  if ((self = [super init])) {
    _userGroupUuid = [userGroupUuid copy];
    _joinedUser = [joinedUser copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userGroupUuid: %@; \n\t joinedUser: %@; \n", [super description], _userGroupUuid, _joinedUser];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_userGroupUuid hash], [_joinedUser hash]};
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

- (BOOL)isEqual:(UserJoinedMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_userGroupUuid == object->_userGroupUuid ? YES : [_userGroupUuid isEqual:object->_userGroupUuid]) &&
    (_joinedUser == object->_joinedUser ? YES : [_joinedUser isEqual:object->_joinedUser]);
}

@end

