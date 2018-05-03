/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMVideoSyncEventMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMVideoSyncEventMessage.h"

static BOOL CompareDoubles(double givenDouble, double doubleToCompare) {
  return fabs(givenDouble - doubleToCompare) < DBL_EPSILON * fabs(givenDouble + doubleToCompare) || fabs(givenDouble - doubleToCompare) < DBL_MIN;
}

static NSUInteger HashDouble(double givenDouble) {
  union {
    double key;
    uint64_t bits;
  } u;
  u.key = givenDouble;
  NSUInteger p = u.bits;
  p = (~p) + (p << 18);
  p ^= (p >> 31);
  p *=  21;
  p ^= (p >> 11);
  p += (p << 6);
  p ^= (p >> 22);
  return (NSUInteger) p;
}

@implementation CMVideoSyncEventMessage

- (instancetype)initWithEvent:(NSString *)event groupUUID:(NSString *)groupUUID showUUID:(NSString *)showUUID isPlaying:(BOOL)isPlaying timestamp:(double)timestamp
{
  if ((self = [super init])) {
    _event = [event copy];
    _groupUUID = [groupUUID copy];
    _showUUID = [showUUID copy];
    _isPlaying = isPlaying;
    _timestamp = timestamp;
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t event: %@; \n\t groupUUID: %@; \n\t showUUID: %@; \n\t isPlaying: %@; \n\t timestamp: %lf; \n", [super description], _event, _groupUUID, _showUUID, _isPlaying ? @"YES" : @"NO", _timestamp];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_event hash], [_groupUUID hash], [_showUUID hash], (NSUInteger)_isPlaying, HashDouble(_timestamp)};
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

- (BOOL)isEqual:(CMVideoSyncEventMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _isPlaying == object->_isPlaying &&
    CompareDoubles(_timestamp, object->_timestamp) &&
    (_event == object->_event ? YES : [_event isEqual:object->_event]) &&
    (_groupUUID == object->_groupUUID ? YES : [_groupUUID isEqual:object->_groupUUID]) &&
    (_showUUID == object->_showUUID ? YES : [_showUUID isEqual:object->_showUUID]);
}

@end

