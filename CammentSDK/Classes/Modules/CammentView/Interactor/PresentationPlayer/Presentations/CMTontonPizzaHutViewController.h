//
//  CMTontonPizzaHutViewController.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 05.12.2017.
//

#import <UIKit/UIKit.h>
#import "CMPresentableByPresentationAction.h"

@interface CMTontonPizzaHutViewController : UIViewController<CMPresentableByPresentationAction>

- (instancetype)initWithSubject:(NSString *)subject;
+ (instancetype)controllerWithSubject:(NSString *)subject;

@end
