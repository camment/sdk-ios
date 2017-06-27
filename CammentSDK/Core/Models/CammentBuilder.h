#import <Foundation/Foundation.h>

@class Camment;
@class AVAsset;

@interface CammentBuilder : NSObject

+ (instancetype)camment;

+ (instancetype)cammentFromExistingCamment:(Camment *)existingCamment;

- (Camment *)build;

- (instancetype)withShowUUID:(NSString *)showUUID;

- (instancetype)withUsersGroupUUID:(NSString *)usersGroupUUID;

- (instancetype)withUuid:(NSString *)uuid;

- (instancetype)withRemoteURL:(NSString *)remoteURL;

- (instancetype)withLocalURL:(NSString *)localURL;

- (instancetype)withLocalAsset:(AVAsset *)localAsset;

@end

