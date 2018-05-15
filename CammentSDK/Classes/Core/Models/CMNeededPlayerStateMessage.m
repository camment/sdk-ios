/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMNeededPlayerStateMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMNeededPlayerStateMessage.h"

@implementation CMNeededPlayerStateMessage

- (instancetype)initWithGroupUUID:(NSString *)groupUUID
{
  if ((self = [super init])) {
    _groupUUID = [groupUUID copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t groupUUID: %@; \n", [super description], _groupUUID];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_groupUUID hash]};
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

- (BOOL)isEqual:(CMNeededPlayerStateMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_groupUUID == object->_groupUUID ? YES : [_groupUUID isEqual:object->_groupUUID]);
}

@end

