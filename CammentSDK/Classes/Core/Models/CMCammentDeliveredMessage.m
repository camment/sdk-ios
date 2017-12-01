/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCammentDeliveredMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCammentDeliveredMessage.h"

@implementation CMCammentDeliveredMessage

- (instancetype)initWithCammentUuid:(NSString *)cammentUuid
{
  if ((self = [super init])) {
    _cammentUuid = [cammentUuid copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t cammentUuid: %@; \n", [super description], _cammentUuid];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_cammentUuid hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 1; ++ii) {
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

- (BOOL)isEqual:(CMCammentDeliveredMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_cammentUuid == object->_cammentUuid ? YES : [_cammentUuid isEqual:object->_cammentUuid]);
}

@end

