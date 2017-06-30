/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Invitation.value
 */

#import <Foundation/Foundation.h>

@interface Invitation : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) NSString *userCognitoUuid;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid userCognitoUuid:(NSString *)userCognitoUuid;

@end

