/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserRemovedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"

@interface CMUserRemovedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) CMUser *removedUser;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid removedUser:(CMUser *)removedUser;

@end

