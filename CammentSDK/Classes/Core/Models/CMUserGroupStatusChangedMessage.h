/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMUserGroupStatusChangedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"

@interface CMUserGroupStatusChangedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *userGroupUuid;
@property (nonatomic, readonly, copy) CMUser *user;
@property (nonatomic, readonly, copy) NSString *state;

- (instancetype)initWithUserGroupUuid:(NSString *)userGroupUuid user:(CMUser *)user state:(NSString *)state;

@end

