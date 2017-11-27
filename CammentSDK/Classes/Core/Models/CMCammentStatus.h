/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCammentStatus.value
 */

#import <Foundation/Foundation.h>
#import "CMCammentDeliveryStatus.h"

@interface CMCammentStatus : NSObject <NSCopying>

@property (nonatomic, readonly) CMCammentDeliveryStatus deliveryStatus;
@property (nonatomic, readonly) BOOL isWatched;

- (instancetype)initWithDeliveryStatus:(CMCammentDeliveryStatus)deliveryStatus isWatched:(BOOL)isWatched;

@end

