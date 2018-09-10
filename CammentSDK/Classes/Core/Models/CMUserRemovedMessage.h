/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserRemovedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"

@interface CMUserRemovedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) CMUser *user;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid user:(CMUser *)user;

@end

