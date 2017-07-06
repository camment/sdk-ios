#import <Foundation/Foundation.h>

@class Invitation;
@class User;

@interface InvitationBuilder : NSObject

+ (instancetype)invitation;

+ (instancetype)invitationFromExistingInvitation:(Invitation *)existingInvitation;

- (Invitation *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withUserCognitoUuid:(NSString *)userCognitoUuid;

- (instancetype)withShowUuid:(NSString *)showUuid;

- (instancetype)withInvitationKey:(NSString *)invitationKey;

- (instancetype)withInvitedUserFacebookId:(NSString *)invitedUserFacebookId;

- (instancetype)withInvitationIssuer:(User *)invitationIssuer;

@end

