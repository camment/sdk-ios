/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMAuthStatusChangedEventContext.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMAuthStatusChangedEventContext.h"

@implementation CMAuthStatusChangedEventContext

- (instancetype)initWithState:(CMCammentUserAuthentificationState)state user:(CMUser *)user
{
  if ((self = [super init])) {
    _state = state;
    _user = [user copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t state: %zd; \n\t user: %@; \n", [super description], _state, _user];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {ABS(_state), [_user hash]};
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

- (BOOL)isEqual:(CMAuthStatusChangedEventContext *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _state == object->_state &&
    (_user == object->_user ? YES : [_user isEqual:object->_user]);
}

@end

