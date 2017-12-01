/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserJoinedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"
#import "CMUsersGroup.h"
#import "CMShow.h"

@interface CMUserJoinedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) CMUsersGroup *usersGroup;
@property (nonatomic, readonly, copy) CMUser *joinedUser;
@property (nonatomic, readonly, copy) CMShow *show;

- (instancetype)initWithUsersGroup:(CMUsersGroup *)usersGroup joinedUser:(CMUser *)joinedUser show:(CMShow *)show;

@end

