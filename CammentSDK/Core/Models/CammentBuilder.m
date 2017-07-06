#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Camment.h"
#import "CammentBuilder.h"

@implementation CammentBuilder
{
  NSString *_showUuid;
  NSString *_userGroupUuid;
  NSString *_uuid;
  NSString *_remoteURL;
  NSString *_localURL;
  NSString *_thumbnailURL;
  NSString *_userCognitoIdentityId;
  AVAsset *_localAsset;
}

+ (instancetype)camment
{
  return [[CammentBuilder alloc] init];
}

+ (instancetype)cammentFromExistingCamment:(Camment *)existingCamment
{
  return [[[[[[[[[CammentBuilder camment]
                 withShowUuid:existingCamment.showUuid]
                withUserGroupUuid:existingCamment.userGroupUuid]
               withUuid:existingCamment.uuid]
              withRemoteURL:existingCamment.remoteURL]
             withLocalURL:existingCamment.localURL]
            withThumbnailURL:existingCamment.thumbnailURL]
           withUserCognitoIdentityId:existingCamment.userCognitoIdentityId]
          withLocalAsset:existingCamment.localAsset];
}

- (Camment *)build
{
  return [[Camment alloc] initWithShowUuid:_showUuid userGroupUuid:_userGroupUuid uuid:_uuid remoteURL:_remoteURL localURL:_localURL thumbnailURL:_thumbnailURL userCognitoIdentityId:_userCognitoIdentityId localAsset:_localAsset];
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

- (instancetype)withLocalAsset:(AVAsset *)localAsset
{
  _localAsset = [localAsset copy];
  return self;
}

@end

