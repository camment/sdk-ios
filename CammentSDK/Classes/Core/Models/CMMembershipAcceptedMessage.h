/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMMembershipAcceptedMessage.value
 */

#import <Foundation/Foundation.h>
#import "CMUsersGroup.h"

@interface CMMembershipAcceptedMessage : NSObject <NSCopying>

@property (nonatomic, readonly, copy) CMUsersGroup *group;

- (instancetype)initWithGroup:(CMUsersGroup *)group;

@end

