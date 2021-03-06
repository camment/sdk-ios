/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMBotCamment.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMBotCamment.h"

@implementation CMBotCamment

- (instancetype)initWithURL:(NSString *)URL botAction:(CMBotAction *)botAction
{
  if ((self = [super init])) {
    _URL = [URL copy];
    _botAction = [botAction copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t URL: %@; \n\t botAction: %@; \n", [super description], _URL, _botAction];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_URL hash], [_botAction hash]};
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

- (BOOL)isEqual:(CMBotCamment *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_URL == object->_URL ? YES : [_URL isEqual:object->_URL]) &&
    (_botAction == object->_botAction ? YES : [_botAction isEqual:object->_botAction]);
}

@end

