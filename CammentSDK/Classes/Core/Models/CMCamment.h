/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCamment.value
 */

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>
#import "CMCammentStatus.h"

@interface CMCamment : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *showUuid;
@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *remoteURL;
@property (nonatomic, readonly, copy) NSString *localURL;
@property (nonatomic, readonly, copy) NSString *thumbnailURL;
@property (nonatomic, readonly, copy) NSString *userCognitoIdentityId;
@property (nonatomic, readonly, copy) NSNumber *showAt;
@property (nonatomic, readonly, copy) AVAsset *localAsset;
@property (nonatomic, readonly) BOOL isMadeByBot;
@property (nonatomic, readonly, copy) NSString *botUuid;
@property (nonatomic, readonly, copy) NSString *botAction;
@property (nonatomic, readonly) BOOL isDeleted;
@property (nonatomic, readonly) BOOL shouldBeDeleted;
@property (nonatomic, readonly, copy) CMCammentStatus *status;

- (instancetype)initWithShowUuid:(NSString *)showUuid userGroupUuid:(NSString *)userGroupUuid uuid:(NSString *)uuid remoteURL:(NSString *)remoteURL localURL:(NSString *)localURL thumbnailURL:(NSString *)thumbnailURL userCognitoIdentityId:(NSString *)userCognitoIdentityId showAt:(NSNumber *)showAt localAsset:(AVAsset *)localAsset isMadeByBot:(BOOL)isMadeByBot botUuid:(NSString *)botUuid botAction:(NSString *)botAction isDeleted:(BOOL)isDeleted shouldBeDeleted:(BOOL)shouldBeDeleted status:(CMCammentStatus *)status;

@end

