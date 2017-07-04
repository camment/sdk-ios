/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Invitation.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Invitation.h"

@implementation Invitation

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid userCognitoUuid:(NSString *)userCognitoUuid showUuid:(NSString *)showUuid invitationIssuer:(User *)invitationIssuer
{
  if ((self = [super init])) {
    _userGroupUuid = [userGroupUuid copy];
    _userCognitoUuid = [userCognitoUuid copy];
    _showUuid = [showUuid copy];
    _invitationIssuer = [invitationIssuer copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userGroupUuid: %@; \n\t userCognitoUuid: %@; \n\t showUuid: %@; \n\t invitationIssuer: %@; \n", [super description], _userGroupUuid, _userCognitoUuid, _showUuid, _invitationIssuer];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_userGroupUuid hash], [_userCognitoUuid hash], [_showUuid hash], [_invitationIssuer hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 4; ++ii) {
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
    (_userCognitoUuid == object->_userCognitoUuid ? YES : [_userCognitoUuid isEqual:object->_userCognitoUuid]) &&
    (_showUuid == object->_showUuid ? YES : [_showUuid isEqual:object->_showUuid]) &&
    (_invitationIssuer == object->_invitationIssuer ? YES : [_invitationIssuer isEqual:object->_invitationIssuer]);
}

@end

