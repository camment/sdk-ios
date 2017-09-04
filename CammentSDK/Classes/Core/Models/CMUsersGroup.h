/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUsersGroup.value
 */

#import <Foundation/Foundation.h>

@interface CMUsersGroup : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *ownerCognitoUserId;
@property (nonatomic, readonly, copy) NSString *timestamp;
@property (nonatomic, readonly, copy) NSString *invitationLink;

- (instancetype)initWithUuid:(NSString *)uuid ownerCognitoUserId:(NSString *)ownerCognitoUserId timestamp:(NSString *)timestamp invitationLink:(NSString *)invitationLink;

@end

