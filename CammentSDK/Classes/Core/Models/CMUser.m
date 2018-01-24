/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUser.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUser.h"

@implementation CMUser

- (instancetype)initWithCognitoUserId:(NSString *)cognitoUserId fbUserId:(NSString *)fbUserId username:(NSString *)username email:(NSString *)email userPhoto:(NSString *)userPhoto state:(NSString *)state
{
  if ((self = [super init])) {
    _cognitoUserId = [cognitoUserId copy];
    _fbUserId = [fbUserId copy];
    _username = [username copy];
    _email = [email copy];
    _userPhoto = [userPhoto copy];
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
  return [NSString stringWithFormat:@"%@ - \n\t cognitoUserId: %@; \n\t fbUserId: %@; \n\t username: %@; \n\t email: %@; \n\t userPhoto: %@; \n\t state: %@; \n", [super description], _cognitoUserId, _fbUserId, _username, _email, _userPhoto, _state];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_cognitoUserId hash], [_fbUserId hash], [_username hash], [_email hash], [_userPhoto hash], [_state hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 6; ++ii) {
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

- (BOOL)isEqual:(CMUser *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_cognitoUserId == object->_cognitoUserId ? YES : [_cognitoUserId isEqual:object->_cognitoUserId]) &&
    (_fbUserId == object->_fbUserId ? YES : [_fbUserId isEqual:object->_fbUserId]) &&
    (_username == object->_username ? YES : [_username isEqual:object->_username]) &&
    (_email == object->_email ? YES : [_email isEqual:object->_email]) &&
    (_userPhoto == object->_userPhoto ? YES : [_userPhoto isEqual:object->_userPhoto]) &&
    (_state == object->_state ? YES : [_state isEqual:object->_state]);
}

@end

