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

- (instancetype)withInvitationIssuer:(User *)invitationIssuer;

@end

