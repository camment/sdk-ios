/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCamment.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCamment.h"

@implementation CMCamment

- (instancetype)initWithShowUuid:(NSString *)showUuid userGroupUuid:(NSString *)userGroupUuid uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL thumbnailURL:(NSString *)thumbnailURL userCognitoIdentityId:(NSString *)userCognitoIdentityId localAsset:(AVAsset *)localAsset isMadeByBot:(BOOL)isMadeByBot botUuid:(NSString *)botUuid botAction:(NSString *)botAction isDeleted:(BOOL)isDeleted shouldBeDeleted:(BOOL)shouldBeDeleted status:(CMCammentStatus *)status
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
    _isMadeByBot = isMadeByBot;
    _botUuid = [botUuid copy];
    _botAction = [botAction copy];
    _isDeleted = isDeleted;
    _shouldBeDeleted = shouldBeDeleted;
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
  return [NSString stringWithFormat:@"%@ - \n\t showUuid: %@; \n\t userGroupUuid: %@; \n\t uuid: %@; \n\t remoteURL: %@; \n\t localURL: %@; \n\t thumbnailURL: %@; \n\t userCognitoIdentityId: %@; \n\t localAsset: %@; \n\t isMadeByBot: %@; \n\t botUuid: %@; \n\t botAction: %@; \n\t isDeleted: %@; \n\t shouldBeDeleted: %@; \n\t status: %@; \n", [super description], _showUuid, _userGroupUuid, _uuid, _remoteURL, _localURL, _thumbnailURL, _userCognitoIdentityId, _localAsset, _isMadeByBot ? @"YES" : @"NO", _botUuid, _botAction, _isDeleted ? @"YES" : @"NO", _shouldBeDeleted ? @"YES" : @"NO", _status];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_showUuid hash], [_userGroupUuid hash], [_uuid hash], [_remoteURL hash], [_localURL hash], [_thumbnailURL hash], [_userCognitoIdentityId hash], [_localAsset hash], (NSUInteger)_isMadeByBot, [_botUuid hash], [_botAction hash], (NSUInteger)_isDeleted, (NSUInteger)_shouldBeDeleted, [_status hash]};
  NSUInteger result = subhashes[0];
  for (int ii = 1; ii < 14; ++ii) {
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

- (BOOL)isEqual:(CMCamment *)object
{
  if (self == object) {
    return YES;
  } else if (self == nil || object == nil || ![object isKindOfClass:[self class]]) {
    return NO;
  }
  return
    _isMadeByBot == object->_isMadeByBot &&
    _isDeleted == object->_isDeleted &&
    _shouldBeDeleted == object->_shouldBeDeleted &&
    (_localAsset == object->_localAsset ? YES : [_localAsset isEqual:object->_localAsset]) &&
    (_localURL == object->_localURL ? YES : [_localURL isEqual:object->_localURL]) &&
    (_thumbnailURL == object->_thumbnailURL ? YES : [_thumbnailURL isEqual:object->_thumbnailURL]) &&
    (_userCognitoIdentityId == object->_userCognitoIdentityId ? YES : [_userCognitoIdentityId isEqual:object->_userCognitoIdentityId]) &&
    (_userGroupUuid == object->_userGroupUuid ? YES : [_userGroupUuid isEqual:object->_userGroupUuid]) &&
    (_showUuid == object->_showUuid ? YES : [_showUuid isEqual:object->_showUuid]) &&
    (_botUuid == object->_botUuid ? YES : [_botUuid isEqual:object->_botUuid]) &&
    (_botAction == object->_botAction ? YES : [_botAction isEqual:object->_botAction]) &&
    (_uuid == object->_uuid ? YES : [_uuid isEqual:object->_uuid]) &&
    (_remoteURL == object->_remoteURL ? YES : [_remoteURL isEqual:object->_remoteURL]) &&
    (_status == object->_status ? YES : [_status isEqual:object->_status]);
}

@end

