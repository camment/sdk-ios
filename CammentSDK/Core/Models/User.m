/**
 * This file is generated using the remodel generation script.
 * The name of the input file is User.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "User.h"

@implementation User

- (instancetype)initWithUserId:(NSInteger)userId username:(NSString *)username firstname:(NSString *)firstname lastname:(NSString *)lastname email:(NSString *)email visibility:(NSString *)visibility
{
  if ((self = [super init])) {
    _userId = userId;
    _username = [username copy];
    _firstname = [firstname copy];
    _lastname = [lastname copy];
    _email = [email copy];
    _visibility = [visibility copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userId: %zd; \n\t username: %@; \n\t firstname: %@; \n\t lastname: %@; \n\t email: %@; \n\t visibility: %@; \n", [super description], _userId, _username, _firstname, _lastname, _email, _visibility];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {ABS(_userId), [_username hash], [_firstname hash], [_lastname hash], [_email hash], [_visibility hash]};
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

- (BOOL)isEqual:(User *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _userId == object->_userId &&
    (_username == object->_username ? YES : [_username isEqual:object->_username]) &&
    (_firstname == object->_firstname ? YES : [_firstname isEqual:object->_firstname]) &&
    (_lastname == object->_lastname ? YES : [_lastname isEqual:object->_lastname]) &&
    (_email == object->_email ? YES : [_email isEqual:object->_email]) &&
    (_visibility == object->_visibility ? YES : [_visibility isEqual:object->_visibility]);
}

@end

