/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CammentDeletedMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CammentDeletedMessage.h"

@implementation CammentDeletedMessage

- (instancetype)initWithCamment:(Camment *)camment
{
  if ((self = [super init])) {
    _camment = [camment copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t camment: %@; \n", [super description], _camment];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_camment hash]};
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

- (BOOL)isEqual:(CammentDeletedMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_camment == object->_camment ? YES : [_camment isEqual:object->_camment]);
}

@end

