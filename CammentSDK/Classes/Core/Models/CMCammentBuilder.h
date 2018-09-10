#import <Foundation/Foundation.h>

@class CMCamment;
@class CMCammentStatus;

@interface CMCammentBuilder : NSObject

+ (instancetype)camment;

+ (instancetype)cammentFromExistingCamment:(CMCamment *)existingCamment;

- (CMCamment *)build;

- (instancetype)withShowUuid:(NSString *)showUuid;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withUuid:(NSString *)uuid;

- (instancetype)withRemoteURL:(NSString *)remoteURL;

- (instancetype)withLocalURL:(NSString *)localURL;

- (instancetype)withThumbnailURL:(NSString *)thumbnailURL;

- (instancetype)withUserCognitoIdentityId:(NSString *)userCognitoIdentityId;

- (instancetype)withShowAt:(NSNumber *)showAt;

- (instancetype)withIsMadeByBot:(BOOL)isMadeByBot;

- (instancetype)withBotUuid:(NSString *)botUuid;

- (instancetype)withBotAction:(NSString *)botAction;

- (instancetype)withIsDeleted:(BOOL)isDeleted;

- (instancetype)withShouldBeDeleted:(BOOL)shouldBeDeleted;

- (instancetype)withStatus:(CMCammentStatus *)status;

@end

