/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserOnlineStatusChangedMessage.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMUserOnlineStatusChangedMessage.h"

@implementation CMUserOnlineStatusChangedMessage

- (instancetype)initWithUserId:(NSString *)userId status:(NSString *)status
{
  if ((self = [super init])) {
    _userId = [userId copy];
    _status = [status copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t userId: %@; \n\t status: %@; \n", [super description], _userId, _status];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_userId hash], [_status hash]};
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

- (BOOL)isEqual:(CMUserOnlineStatusChangedMessage *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_userId == object->_userId ? YES : [_userId isEqual:object->_userId]) &&
    (_status == object->_status ? YES : [_status isEqual:object->_status]);
}

@end

