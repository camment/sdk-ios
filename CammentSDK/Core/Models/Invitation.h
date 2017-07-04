/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Invitation.value
 */

#import <Foundation/Foundation.h>
#import "User.h"

@interface Invitation : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) NSString *userCognitoUuid;
@property (nonatomic, readonly, copy) NSString *showUuid;
@property (nonatomic, readonly, copy) User *invitationIssuer;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid userCognitoUuid:(NSString *)userCognitoUuid showUuid:(NSString *)showUuid invitationIssuer:(User *)invitationIssuer;

@end

