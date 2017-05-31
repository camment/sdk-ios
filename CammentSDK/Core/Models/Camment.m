/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Camment.h"
#import "Ads.h"

@implementation Camment

- (instancetype)initWithShowUUID:(NSString *)showUUID cammentUUID:(NSString *)cammentUUID remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL localAsset:(AVAsset *)localAsset temporaryUUID:(NSString *)temporaryUUID
{
  if ((self = [super init])) {
    _showUUID = [showUUID copy];
    _cammentUUID = [cammentUUID copy];
    _remoteURL = [remoteURL copy];
    _localURL = [localURL copy];
    _localAsset = [localAsset copy];
    _temporaryUUID = [temporaryUUID copy];
  }

  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"%@ - \n\t showUUID: %@; \n\t cammentUUID: %@; \n\t remoteURL: %@; \n\t localURL: %@; \n\t localAsset: %@; \n\t temporaryUUID: %@; \n", [super description], _showUUID, _cammentUUID, _remoteURL, _localURL, _localAsset, _temporaryUUID];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_showUUID hash], [_cammentUUID hash], [_remoteURL hash], [_localURL hash], [_localAsset hash], [_temporaryUUID hash]};
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
    (_cammentUUID == object->_cammentUUID ? YES : [_cammentUUID isEqual:object->_cammentUUID]) &&
    (_remoteURL == object->_remoteURL ? YES : [_remoteURL isEqual:object->_remoteURL]) &&
    (_localURL == object->_localURL ? YES : [_localURL isEqual:object->_localURL]) &&
    (_localAsset == object->_localAsset ? YES : [_localAsset isEqual:object->_localAsset]) &&
    (_temporaryUUID == object->_temporaryUUID ? YES : [_temporaryUUID isEqual:object->_temporaryUUID]);
}

@end

