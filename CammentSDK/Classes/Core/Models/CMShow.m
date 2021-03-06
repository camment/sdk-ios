/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMShow.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMShow.h"

@implementation CMShow

- (instancetype)initWithUuid:(NSString *)uuid url:(NSString *)url thumbnail:(NSString *)thumbnail showType:(CMShowType *)showType startsAt:(NSNumber *)startsAt
{
  if ((self = [super init])) {
    _uuid = [uuid copy];
    _url = [url copy];
    _thumbnail = [thumbnail copy];
    _showType = [showType copy];
    _startsAt = [startsAt copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t uuid: %@; \n\t url: %@; \n\t thumbnail: %@; \n\t showType: %@; \n\t startsAt: %@; \n", [super description], _uuid, _url, _thumbnail, _showType, _startsAt];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_uuid hash], [_url hash], [_thumbnail hash], [_showType hash], [_startsAt hash]};
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

- (BOOL)isEqual:(CMShow *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_url == object->_url ? YES : [_url isEqual:object->_url]) &&
    (_thumbnail == object->_thumbnail ? YES : [_thumbnail isEqual:object->_thumbnail]) &&
    (_showType == object->_showType ? YES : [_showType isEqual:object->_showType]) &&
    (_startsAt == object->_startsAt ? YES : [_startsAt isEqual:object->_startsAt]);
}

@end

