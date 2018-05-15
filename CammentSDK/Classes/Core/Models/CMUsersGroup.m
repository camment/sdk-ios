/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUsersGroup.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUsersGroup.h"

@implementation CMUsersGroup

- (instancetype)initWithUuid:(NSString *)uuid ownerCognitoUserId:(NSString *)ownerCognitoUserId hostCognitoUserId:(NSString *)hostCognitoUserId timestamp:(NSString *)timestamp invitationLink:(NSString *)invitationLink
{
  if ((self = [super init])) {
    _uuid = [uuid copy];
    _ownerCognitoUserId = [ownerCognitoUserId copy];
    _hostCognitoUserId = [hostCognitoUserId copy];
    _timestamp = [timestamp copy];
    _invitationLink = [invitationLink copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t uuid: %@; \n\t ownerCognitoUserId: %@; \n\t hostCognitoUserId: %@; \n\t timestamp: %@; \n\t invitationLink: %@; \n", [super description], _uuid, _ownerCognitoUserId, _hostCognitoUserId, _timestamp, _invitationLink];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_uuid hash], [_ownerCognitoUserId hash], [_hostCognitoUserId hash], [_timestamp hash], [_invitationLink hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 5; ++ii) {
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

- (BOOL)isEqual:(CMUsersGroup *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_ownerCognitoUserId == object->_ownerCognitoUserId ? YES : [_ownerCognitoUserId isEqual:object->_ownerCognitoUserId]) &&
    (_hostCognitoUserId == object->_hostCognitoUserId ? YES : [_hostCognitoUserId isEqual:object->_hostCognitoUserId]) &&
    (_timestamp == object->_timestamp ? YES : [_timestamp isEqual:object->_timestamp]) &&
    (_invitationLink == object->_invitationLink ? YES : [_invitationLink isEqual:object->_invitationLink]);
}

@end

