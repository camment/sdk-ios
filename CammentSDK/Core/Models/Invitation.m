/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Invitation.value
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Invitation.h"

@implementation Invitation

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid userCognitoUuid:(NSString *)userCognitoUuid
{
  if ((self = [super init])) {
    _userGroupUuid = [userGroupUuid copy];
    _userCognitoUuid = [userCognitoUuid copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userGroupUuid: %@; \n\t userCognitoUuid: %@; \n", [super description], _userGroupUuid, _userCognitoUuid];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_userGroupUuid hash], [_userCognitoUuid hash]};
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

- (BOOL)isEqual:(Invitation *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_userGroupUuid == object->_userGroupUuid ? YES : [_userGroupUuid isEqual:object->_userGroupUuid]) &&
    (_userCognitoUuid == object->_userCognitoUuid ? YES : [_userCognitoUuid isEqual:object->_userCognitoUuid]);
}

@end


#pragma clang diagnostic pop