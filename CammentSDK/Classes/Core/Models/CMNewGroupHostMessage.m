/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMNewGroupHostMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMNewGroupHostMessage.h"

@implementation CMNewGroupHostMessage

- (instancetype)initWithGroupUuid:(NSString *)groupUuid hostId:(NSString *)hostId
{
  if ((self = [super init])) {
    _groupUuid = [groupUuid copy];
    _hostId = [hostId copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t groupUuid: %@; \n\t hostId: %@; \n", [super description], _groupUuid, _hostId];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_groupUuid hash], [_hostId hash]};
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

- (BOOL)isEqual:(CMNewGroupHostMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_groupUuid == object->_groupUuid ? YES : [_groupUuid isEqual:object->_groupUuid]) &&
    (_hostId == object->_hostId ? YES : [_hostId isEqual:object->_hostId]);
}

@end

