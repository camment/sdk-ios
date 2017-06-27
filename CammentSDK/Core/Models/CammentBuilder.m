#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "Camment.h"
#import "CammentBuilder.h"

@implementation CammentBuilder
{
  NSString *_showUUID;
  NSString *_usersGroupUUID;
  NSString *_uuid;
  NSString *_remoteURL;
  NSString *_localURL;
  AVAsset *_localAsset;
}

+ (instancetype)camment
{
  return [[CammentBuilder alloc] init];
}

+ (instancetype)cammentFromExistingCamment:(Camment *)existingCamment
{
  return [[[[[[[CammentBuilder camment]
               withShowUUID:existingCamment.showUUID]
              withUsersGroupUUID:existingCamment.usersGroupUUID]
             withUuid:existingCamment.uuid]
            withRemoteURL:existingCamment.remoteURL]
           withLocalURL:existingCamment.localURL]
          withLocalAsset:existingCamment.localAsset];
}

- (Camment *)build
{
  return [[Camment alloc] initWithShowUUID:_showUUID usersGroupUUID:_usersGroupUUID uuid:_uuid remoteURL:_remoteURL localURL:_localURL localAsset:_localAsset];
}

- (instancetype)withShowUUID:(NSString *)showUUID
{
  _showUUID = [showUUID copy];
  return self;
}

- (instancetype)withUsersGroupUUID:(NSString *)usersGroupUUID
{
  _usersGroupUUID = [usersGroupUUID copy];
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

- (instancetype)withLocalAsset:(AVAsset *)localAsset
{
  _localAsset = [localAsset copy];
  return self;
}

@end

