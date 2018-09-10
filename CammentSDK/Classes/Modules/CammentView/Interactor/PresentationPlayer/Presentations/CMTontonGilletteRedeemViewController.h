//
//  CMTontonGilletteRedeemViewController.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 04.12.2017.
//

#import <UIKit/UIKit.h>
#import "CMPresentableByPresentationAction.h"

@interface CMTontonGilletteRedeemViewController : UIViewController<CMPresentableByPresentationAction>

- (instancetype)initWithSubject:(NSString *)subject;
+ (instancetype)controllerWithSubject:(NSString *)subject;

@end
