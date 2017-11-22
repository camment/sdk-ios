/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMInvitation.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"

@interface CMInvitation : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) NSString *userCognitoUuid;
@property (nonatomic, readonly, copy) NSString *showUuid;
@property (nonatomic, readonly, copy) NSString *invitedUserFacebookId;
@property (nonatomic, readonly, copy) CMUser *invitationIssuer;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid userCognitoUuid:(NSString *)userCognitoUuid showUuid:(NSString *)showUuid invitedUserFacebookId:(NSString *)invitedUserFacebookId invitationIssuer:(CMUser *)invitationIssuer;

@end

