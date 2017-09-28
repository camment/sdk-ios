//
//  CMPublicModuleInterface.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 29.05.17.
//  Copyright © 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CMPublicModuleInterface <NSObject>

- (void)presentInWindow:(UIWindow *)window;
- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end
