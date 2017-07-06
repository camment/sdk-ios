/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Camment.h"
#import "CammentDeletedMessage.h"

@implementation Camment

- (instancetype)initWithShowUuid:(NSString *)showUuid userGroupUuid:(NSString *)userGroupUuid uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL thumbnailURL:(NSString *)thumbnailURL userCognitoIdentityId:(NSString *)userCognitoIdentityId localAsset:(AVAsset *)localAsset
{
  if ((self = [super init])) {
    _showUuid = [showUuid copy];
    _userGroupUuid = [userGroupUuid copy];
    _uuid = [uuid copy];
    _remoteURL = [remoteURL copy];
    _localURL = [localURL copy];
    _thumbnailURL = [thumbnailURL copy];
    _userCognitoIdentityId = [userCognitoIdentityId copy];
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
  return [NSString stringWithFormat:@"%@ - \n\t showUuid: %@; \n\t userGroupUuid: %@; \n\t uuid: %@; \n\t remoteURL: %@; \n\t localURL: %@; \n\t thumbnailURL: %@; \n\t userCognitoIdentityId: %@; \n\t localAsset: %@; \n", [super description], _showUuid, _userGroupUuid, _uuid, _remoteURL, _localURL, _thumbnailURL, _userCognitoIdentityId, _localAsset];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_showUuid hash], [_userGroupUuid hash], [_uuid hash], [_remoteURL hash], [_localURL hash], [_thumbnailURL hash], [_userCognitoIdentityId hash], [_localAsset hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 8; ++ii) {
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
    (_showUuid == object->_showUuid ? YES : [_showUuid isEqual:object->_showUuid]) &&
    (_userGroupUuid == object->_userGroupUuid ? YES : [_userGroupUuid isEqual:object->_userGroupUuid]) &&
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_remoteURL == object->_remoteURL ? YES : [_remoteURL isEqual:object->_remoteURL]) &&
    (_localURL == object->_localURL ? YES : [_localURL isEqual:object->_localURL]) &&
    (_thumbnailURL == object->_thumbnailURL ? YES : [_thumbnailURL isEqual:object->_thumbnailURL]) &&
    (_userCognitoIdentityId == object->_userCognitoIdentityId ? YES : [_userCognitoIdentityId isEqual:object->_userCognitoIdentityId]) &&
    (_localAsset == object->_localAsset ? YES : [_localAsset isEqual:object->_localAsset]);
}

@end

