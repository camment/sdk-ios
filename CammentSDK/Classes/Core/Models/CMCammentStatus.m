/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCammentStatus.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCammentStatus.h"

@implementation CMCammentStatus

- (instancetype)initWithDeliveryStatus:(CMCammentDeliveryStatus)deliveryStatus isWatched:(BOOL)isWatched
{
  if ((self = [super init])) {
    _deliveryStatus = deliveryStatus;
    _isWatched = isWatched;
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t deliveryStatus: %zd; \n\t isWatched: %@; \n", [super description], _deliveryStatus, _isWatched ? @"YES" : @"NO"];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {ABS(_deliveryStatus), (NSUInteger)_isWatched};
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

- (BOOL)isEqual:(CMCammentStatus *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _deliveryStatus == object->_deliveryStatus &&
    _isWatched == object->_isWatched;
}

@end

