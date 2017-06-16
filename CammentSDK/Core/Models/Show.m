/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Show.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Show.h"

@implementation Show

- (instancetype)initWithUuid:(NSString *)uuid url:(NSString *)url showType:(ShowType *)showType
{
  if ((self = [super init])) {
    _uuid = [uuid copy];
    _url = [url copy];
    _showType = [showType copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t uuid: %@; \n\t url: %@; \n\t showType: %@; \n", [super description], _uuid, _url, _showType];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_uuid hash], [_url hash], [_showType hash]};
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

- (BOOL)isEqual:(Show *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_url == object->_url ? YES : [_url isEqual:object->_url]) &&
    (_showType == object->_showType ? YES : [_showType isEqual:object->_showType]);
}

@end

