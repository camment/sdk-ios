/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMAuthStatusChangedEventContext.value
 */

#import <Foundation/Foundation.h>
#import "CMCammentUserAuthentificationState.h"
#import "CMUser.h"

@interface CMAuthStatusChangedEventContext : NSObject <NSCopying>

@property (nonatomic, readonly) CMCammentUserAuthentificationState state;
@property (nonatomic, readonly, copy) CMUser *user;

- (instancetype)initWithState:(CMCammentUserAuthentificationState)state user:(CMUser *)user;

@end

