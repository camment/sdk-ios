/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCamment.value
 */

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCamment.h"

static __unsafe_unretained NSString * const kShowUuidKey = @"SHOW_UUID";
static __unsafe_unretained NSString * const kUserGroupUuidKey = @"USER_GROUP_UUID";
static __unsafe_unretained NSString * const kUuidKey = @"UUID";
static __unsafe_unretained NSString * const kRemoteURLKey = @"REMOTE_URL";
static __unsafe_unretained NSString * const kLocalURLKey = @"LOCAL_URL";
static __unsafe_unretained NSString * const kThumbnailURLKey = @"THUMBNAIL_URL";
static __unsafe_unretained NSString * const kUserCognitoIdentityIdKey = @"USER_COGNITO_IDENTITY_ID";
static __unsafe_unretained NSString * const kShowAtKey = @"SHOW_AT";
static __unsafe_unretained NSString * const kIsMadeByBotKey = @"IS_MADE_BY_BOT";
static __unsafe_unretained NSString * const kBotUuidKey = @"BOT_UUID";
static __unsafe_unretained NSString * const kBotActionKey = @"BOT_ACTION";
static __unsafe_unretained NSString * const kIsDeletedKey = @"IS_DELETED";
static __unsafe_unretained NSString * const kShouldBeDeletedKey = @"SHOULD_BE_DELETED";
static __unsafe_unretained NSString * const kStatusKey = @"STATUS";

@implementation CMCamment

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  if ((self = [super init])) {
    _showUuid = [aDecoder decodeObjectForKey:kShowUuidKey];
    _userGroupUuid = [aDecoder decodeObjectForKey:kUserGroupUuidKey];
    _uuid = [aDecoder decodeObjectForKey:kUuidKey];
    _remoteURL = [aDecoder decodeObjectForKey:kRemoteURLKey];
    _localURL = [aDecoder decodeObjectForKey:kLocalURLKey];
    _thumbnailURL = [aDecoder decodeObjectForKey:kThumbnailURLKey];
    _userCognitoIdentityId = [aDecoder decodeObjectForKey:kUserCognitoIdentityIdKey];
    _showAt = [aDecoder decodeObjectForKey:kShowAtKey];
    _isMadeByBot = [aDecoder decodeBoolForKey:kIsMadeByBotKey];
    _botUuid = [aDecoder decodeObjectForKey:kBotUuidKey];
    _botAction = [aDecoder decodeObjectForKey:kBotActionKey];
    _isDeleted = [aDecoder decodeBoolForKey:kIsDeletedKey];
    _shouldBeDeleted = [aDecoder decodeBoolForKey:kShouldBeDeletedKey];
    _status = [aDecoder decodeObjectForKey:kStatusKey];
  }
  return self;
}

- (instancetype)initWithShowUuid:(NSString *)showUuid userGroupUuid:(NSString *)userGroupUuid uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL thumbnailURL:(NSString *)thumbnailURL userCognitoIdentityId:(NSString *)userCognitoIdentityId showAt:(NSNumber *)showAt isMadeByBot:(BOOL)isMadeByBot botUuid:(NSString *)botUuid botAction:(NSString *)botAction isDeleted:(BOOL)isDeleted shouldBeDeleted:(BOOL)shouldBeDeleted status:(CMCammentStatus *)status
{
  if ((self = [super init])) {
    _showUuid = [showUuid copy];
    _userGroupUuid = [userGroupUuid copy];
    _uuid = [uuid copy];
    _remoteURL = [remoteURL copy];
    _localURL = [localURL copy];
    _thumbnailURL = [thumbnailURL copy];
    _userCognitoIdentityId = [userCognitoIdentityId copy];
    _showAt = [showAt copy];
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
  return [NSString stringWithFormat:@"%@ - \n\t showUuid: %@; \n\t userGroupUuid: %@; \n\t uuid: %@; \n\t remoteURL: %@; \n\t localURL: %@; \n\t thumbnailURL: %@; \n\t userCognitoIdentityId: %@; \n\t showAt: %@; \n\t isMadeByBot: %@; \n\t botUuid: %@; \n\t botAction: %@; \n\t isDeleted: %@; \n\t shouldBeDeleted: %@; \n\t status: %@; \n", [super description], _showUuid, _userGroupUuid, _uuid, _remoteURL, _localURL, _thumbnailURL, _userCognitoIdentityId, _showAt, _isMadeByBot ? @"YES" : @"NO", _botUuid, _botAction, _isDeleted ? @"YES" : @"NO", _shouldBeDeleted ? @"YES" : @"NO", _status];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:_showUuid forKey:kShowUuidKey];
  [aCoder encodeObject:_userGroupUuid forKey:kUserGroupUuidKey];
  [aCoder encodeObject:_uuid forKey:kUuidKey];
  [aCoder encodeObject:_remoteURL forKey:kRemoteURLKey];
  [aCoder encodeObject:_localURL forKey:kLocalURLKey];
  [aCoder encodeObject:_thumbnailURL forKey:kThumbnailURLKey];
  [aCoder encodeObject:_userCognitoIdentityId forKey:kUserCognitoIdentityIdKey];
  [aCoder encodeObject:_showAt forKey:kShowAtKey];
  [aCoder encodeBool:_isMadeByBot forKey:kIsMadeByBotKey];
  [aCoder encodeObject:_botUuid forKey:kBotUuidKey];
  [aCoder encodeObject:_botAction forKey:kBotActionKey];
  [aCoder encodeBool:_isDeleted forKey:kIsDeletedKey];
  [aCoder encodeBool:_shouldBeDeleted forKey:kShouldBeDeletedKey];
  [aCoder encodeObject:_status forKey:kStatusKey];
}

- (NSUInteger)hash
{
  NSUInteger subhashes[] = {[_showUuid hash], [_userGroupUuid hash], [_uuid hash], [_remoteURL hash], [_localURL hash], [_thumbnailURL hash], [_userCognitoIdentityId hash], [_showAt hash], (NSUInteger)_isMadeByBot, [_botUuid hash], [_botAction hash], (NSUInteger)_isDeleted, (NSUInteger)_shouldBeDeleted, [_status hash]};
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
    (_showAt == object->_showAt ? YES : [_showAt isEqual:object->_showAt]) &&
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

