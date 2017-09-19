/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCamment.value
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>

@interface CMCamment : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *showUuid;
@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *remoteURL;
@property (nonatomic, readonly, copy) NSString *localURL;
@property (nonatomic, readonly, copy) NSString *thumbnailURL;
@property (nonatomic, readonly, copy) NSString *userCognitoIdentityId;
@property (nonatomic, readonly, copy) AVAsset *localAsset;
@property (nonatomic, readonly) BOOL isMadeByBot;
@property (nonatomic, readonly, copy) NSString *botUuid;
@property (nonatomic, readonly, copy) NSString *botAction;

- (instancetype)initWithShowUuid:(NSString *)showUuid userGroupUuid:(NSString *)userGroupUuid uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL thumbnailURL:(NSString *)thumbnailURL userCognitoIdentityId:(NSString *)userCognitoIdentityId localAsset:(AVAsset *)localAsset isMadeByBot:(BOOL)isMadeByBot botUuid:(NSString *)botUuid botAction:(NSString *)botAction;

@end

