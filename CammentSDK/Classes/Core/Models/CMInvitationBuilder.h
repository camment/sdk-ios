#import <Foundation/Foundation.h>

@class CMInvitation;
@class CMUser;

@interface CMInvitationBuilder : NSObject

+ (instancetype)invitation;

+ (instancetype)invitationFromExistingInvitation:(CMInvitation *)existingInvitation;

- (CMInvitation *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withUserCognitoUuid:(NSString *)userCognitoUuid;

- (instancetype)withShowUuid:(NSString *)showUuid;

- (instancetype)withInvitedUserFacebookId:(NSString *)invitedUserFacebookId;

- (instancetype)withInvitationIssuer:(CMUser *)invitationIssuer;

@end

