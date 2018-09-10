/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMMembershipAcceptedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUsersGroup.h"
#import "CMShow.h"

@interface CMMembershipAcceptedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) CMUsersGroup *group;
@property (nonatomic, readonly, copy) CMShow *show;

- (instancetype)initWithGroup:(CMUsersGroup *)group show:(CMShow *)show;

@end

