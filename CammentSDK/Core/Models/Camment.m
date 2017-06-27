/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Camment.h"

@implementation Camment

- (instancetype)initWithShowUUID:(NSString *)showUUID usersGroupUUID:(NSString *)usersGroupUUID uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL localAsset:(AVAsset *)localAsset
{
  if ((self = [super init])) {
    _showUUID = [showUUID copy];
    _usersGroupUUID = [usersGroupUUID copy];
    _uuid = [uuid copy];
    _remoteURL = [remoteURL copy];
    _localURL = [localURL copy];
    _localAsset = [localAsset copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t showUUID: %@; \n\t usersGroupUUID: %@; \n\t uuid: %@; \n\t remoteURL: %@; \n\t localURL: %@; \n\t localAsset: %@; \n", [super description], _showUUID, _usersGroupUUID, _uuid, _remoteURL, _localURL, _localAsset];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_showUUID hash], [_usersGroupUUID hash], [_uuid hash], [_remoteURL hash], [_localURL hash], [_localAsset hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 6; ++ii) {
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

- (BOOL)isEqual:(Camment *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    (_showUUID == object->_showUUID ? YES : [_showUUID isEqual:object->_showUUID]) &&
    (_usersGroupUUID == object->_usersGroupUUID ? YES : [_usersGroupUUID isEqual:object->_usersGroupUUID]) &&
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_remoteURL == object->_remoteURL ? YES : [_remoteURL isEqual:object->_remoteURL]) &&
    (_localURL == object->_localURL ? YES : [_localURL isEqual:object->_localURL]) &&
    (_localAsset == object->_localAsset ? YES : [_localAsset isEqual:object->_localAsset]);
}

@end

