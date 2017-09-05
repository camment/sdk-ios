//
//  CMGroupManagementCMGroupManagementWireframe.h
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMGroupManagementPresenter.h"
#import "CMGroupManagementInteractor.h"
#import "CMGroupManagementViewController.h"

@interface CMGroupManagementWireframe : NSObject

@property (nonatomic, weak) CMGroupManagementViewController *view;
@property (nonatomic, weak) CMGroupManagementPresenter *presenter;
@property (nonatomic, weak) CMGroupManagementInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

- (void)presentInWindow:(UIWindow *)window;
- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end