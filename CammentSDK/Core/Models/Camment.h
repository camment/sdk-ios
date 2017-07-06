/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Camment.value
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>

@interface Camment : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *showUuid;
@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *remoteURL;
@property (nonatomic, readonly, copy) NSString *localURL;
@property (nonatomic, readonly, copy) NSString *thumbnailURL;
@property (nonatomic, readonly, copy) NSString *userCognitoIdentityId;
@property (nonatomic, readonly, copy) AVAsset *localAsset;

- (instancetype)initWithShowUuid:(NSString *)showUuid userGroupUuid:(NSString *)userGroupUuid uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL thumbnailURL:(NSString *)thumbnailURL userCognitoIdentityId:(NSString *)userCognitoIdentityId localAsset:(AVAsset *)localAsset;

@end

