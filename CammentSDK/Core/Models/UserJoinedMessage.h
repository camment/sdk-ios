/**
 * This file is generated using the remodel generation script.
 * The name of the input file is UserJoinedMessage.value
 */

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserJoinedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) User *joinedUser;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid joinedUser:(User *)joinedUser;

@end

