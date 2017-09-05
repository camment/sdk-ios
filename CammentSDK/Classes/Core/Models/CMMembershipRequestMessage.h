/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMMembershipRequestMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"
#import "CMUsersGroup.h"

@interface CMMembershipRequestMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) CMUser *joiningUser;
@property (nonatomic, readonly, copy) CMUsersGroup *group;

- (instancetype)initWithJoiningUser:(CMUser *)joiningUser group:(CMUsersGroup *)group;

@end

