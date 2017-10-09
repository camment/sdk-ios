/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMMembershipRequestMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUser.h"
#import "CMUsersGroup.h"
#import "CMShow.h"

@interface CMMembershipRequestMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) CMUser *joiningUser;
@property (nonatomic, readonly, copy) CMUsersGroup *group;
@property (nonatomic, readonly, copy) CMShow *show;

- (instancetype)initWithJoiningUser:(CMUser *)joiningUser group:(CMUsersGroup *)group show:(CMShow *)show;

@end

