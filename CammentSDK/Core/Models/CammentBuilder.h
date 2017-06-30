#import <Foundation/Foundation.h>

@class Camment;
@class AVAsset;

@interface CammentBuilder : NSObject

+ (instancetype)camment;

+ (instancetype)cammentFromExistingCamment:(Camment *)existingCamment;

- (Camment *)build;

- (instancetype)withShowUuid:(NSString *)showUuid;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withUuid:(NSString *)uuid;

- (instancetype)withRemoteURL:(NSString *)remoteURL;

- (instancetype)withLocalURL:(NSString *)localURL;

- (instancetype)withThumbnailURL:(NSString *)thumbnailURL;

- (instancetype)withLocalAsset:(AVAsset *)localAsset;

@end

