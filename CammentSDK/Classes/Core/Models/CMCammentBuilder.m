#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CMCamment.h"
#import "CMCammentBuilder.h"
#import "CMCammentStatus.h"

@implementation CMCammentBuilder
{
  NSString *_showUuid;
  NSString *_userGroupUuid;
  NSString *_uuid;
  NSString *_remoteURL;
  NSString *_localURL;
  NSString *_thumbnailURL;
  NSString *_userCognitoIdentityId;
  NSNumber *_showAt;
  BOOL _isMadeByBot;
  NSString *_botUuid;
  NSString *_botAction;
  BOOL _isDeleted;
  BOOL _shouldBeDeleted;
  CMCammentStatus *_status;
}

+ (instancetype)camment
{
  return [[CMCammentBuilder alloc] init];
}

+ (instancetype)cammentFromExistingCamment:(CMCamment *)existingCamment
{
  return [[[[[[[[[[[[[[[CMCammentBuilder camment]
                       withShowUuid:existingCamment.showUuid]
                      withUserGroupUuid:existingCamment.userGroupUuid]
                     withUuid:existingCamment.uuid]
                    withRemoteURL:existingCamment.remoteURL]
                   withLocalURL:existingCamment.localURL]
                  withThumbnailURL:existingCamment.thumbnailURL]
                 withUserCognitoIdentityId:existingCamment.userCognitoIdentityId]
                withShowAt:existingCamment.showAt]
               withIsMadeByBot:existingCamment.isMadeByBot]
              withBotUuid:existingCamment.botUuid]
             withBotAction:existingCamment.botAction]
            withIsDeleted:existingCamment.isDeleted]
           withShouldBeDeleted:existingCamment.shouldBeDeleted]
          withStatus:existingCamment.status];
}

- (CMCamment *)build
{
  return [[CMCamment alloc] initWithShowUuid:_showUuid userGroupUuid:_userGroupUuid uuid:_uuid remoteURL:_remoteURL localURL:_localURL thumbnailURL:_thumbnailURL userCognitoIdentityId:_userCognitoIdentityId showAt:_showAt isMadeByBot:_isMadeByBot botUuid:_botUuid botAction:_botAction isDeleted:_isDeleted shouldBeDeleted:_shouldBeDeleted status:_status];
}

- (instancetype)withShowUuid:(NSString *)showUuid
{
  _showUuid = [showUuid copy];
  return self;
}

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid
{
  _userGroupUuid = [userGroupUuid copy];
  return self;
}

- (instancetype)withUuid:(NSString *)uuid
{
  _uuid = [uuid copy];
  return self;
}

- (instancetype)withRemoteURL:(NSString *)remoteURL
{
  _remoteURL = [remoteURL copy];
  return self;
}

- (instancetype)withLocalURL:(NSString *)localURL
{
  _localURL = [localURL copy];
  return self;
}

- (instancetype)withThumbnailURL:(NSString *)thumbnailURL
{
  _thumbnailURL = [thumbnailURL copy];
  return self;
}

- (instancetype)withUserCognitoIdentityId:(NSString *)userCognitoIdentityId
{
  _userCognitoIdentityId = [userCognitoIdentityId copy];
  return self;
}

- (instancetype)withShowAt:(NSNumber *)showAt
{
  _showAt = [showAt copy];
  return self;
}

- (instancetype)withIsMadeByBot:(BOOL)isMadeByBot
{
  _isMadeByBot = isMadeByBot;
  return self;
}

- (instancetype)withBotUuid:(NSString *)botUuid
{
  _botUuid = [botUuid copy];
  return self;
}

- (instancetype)withBotAction:(NSString *)botAction
{
  _botAction = [botAction copy];
  return self;
}

- (instancetype)withIsDeleted:(BOOL)isDeleted
{
  _isDeleted = isDeleted;
  return self;
}

- (instancetype)withShouldBeDeleted:(BOOL)shouldBeDeleted
{
  _shouldBeDeleted = shouldBeDeleted;
  return self;
}

- (instancetype)withStatus:(CMCammentStatus *)status
{
  _status = [status copy];
  return self;
}

@end

