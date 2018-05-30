/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUsersGroup.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"

@interface CMUsersGroup : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *showUuid;
@property (nonatomic, readonly, copy) NSString *ownerCognitoUserId;
@property (nonatomic, readonly, copy) NSString *hostCognitoUserId;
@property (nonatomic, readonly, copy) NSString *timestamp;
@property (nonatomic, readonly, copy) NSString *invitationLink;
@property (nonatomic, readonly, copy) NSArray<CMUser *> *users;

- (instancetype)initWithUuid:(NSString *)uuid showUuid:(NSString *)showUuid ownerCognitoUserId:(NSString *)ownerCognitoUserId hostCognitoUserId:(NSString *)hostCognitoUserId timestamp:(NSString *)timestamp invitationLink:(NSString *)invitationLink users:(NSArray<CMUser *> *)users;

@end

