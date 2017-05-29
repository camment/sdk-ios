//
//  CMShowsListModule.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 29.05.17.
//  Copyright © 2017 Camment. All rights reserved.
//

#import "CMShowsListModule.h"
#import "CMShowsListWireframe.h"

@implementation CMShowsListModule

- (void)presentInWindow:(UIWindow *)window {
    [[CMShowsListWireframe new] presentInWindow:window];
}

- (void)presentInViewController:(UIViewController *)viewController {
    [[CMShowsListWireframe new] presentInViewController:viewController];
}

- (void)pushInNavigationController:(UINavigationController *)navigationController {
    [[CMShowsListWireframe new] pushInNavigationController:navigationController];
}

@end
