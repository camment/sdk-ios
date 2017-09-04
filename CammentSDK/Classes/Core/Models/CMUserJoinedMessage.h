/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserJoinedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"

@interface CMUserJoinedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) CMUser *joinedUser;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid joinedUser:(CMUser *)joinedUser;

@end

