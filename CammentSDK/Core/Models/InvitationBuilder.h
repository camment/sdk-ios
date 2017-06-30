#import <Foundation/Foundation.h>

@class Invitation;

@interface InvitationBuilder : NSObject

+ (instancetype)invitation;

+ (instancetype)invitationFromExistingInvitation:(Invitation *)existingInvitation;

- (Invitation *)build;

- (instancetype)withUserGroupUuid:(NSString *)userGroupUuid;

- (instancetype)withUserCognitoUuid:(NSString *)userCognitoUuid;

@end

