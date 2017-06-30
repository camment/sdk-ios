/**
 * This file is generated using the remodel generation script.
 * The name of the input file is UsersGroup.value
 */

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconversion"
#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "UsersGroup.h"

@implementation UsersGroup

- (instancetype)initWithUuid:(NSString *)uuid ownerCognitoUserId:(NSString *)ownerCognitoUserId timestamp:(NSString *)timestamp
{
  if ((self = [super init])) {
    _uuid = [uuid copy];
    _ownerCognitoUserId = [ownerCognitoUserId copy];
    _timestamp = [timestamp copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t uuid: %@; \n\t ownerCognitoUserId: %@; \n\t timestamp: %@; \n", [super description], _uuid, _ownerCognitoUserId, _timestamp];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_uuid hash], [_ownerCognitoUserId hash], [_timestamp hash]};
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

- (BOOL)isEqual:(UsersGroup *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_ownerCognitoUserId == object->_ownerCognitoUserId ? YES : [_ownerCognitoUserId isEqual:object->_ownerCognitoUserId]) &&
    (_timestamp == object->_timestamp ? YES : [_timestamp isEqual:object->_timestamp]);
}

@end


#pragma clang diagnostic pop