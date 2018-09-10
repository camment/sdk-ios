//
//  CMCammentDeliveryIndicator.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 27.11.2017.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentDeliveryStatus.h"

@interface CMCammentDeliveryIndicator : ASDisplayNode

@property (nonatomic) CMCammentDeliveryStatus deliveryStatus;

@end
