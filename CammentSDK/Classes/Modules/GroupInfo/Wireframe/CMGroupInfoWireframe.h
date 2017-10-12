//
//  CMGroupInfoCMGroupInfoWireframe.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMGroupInfoPresenter.h"
#import "CMGroupInfoInteractor.h"
#import "CMGroupInfoViewController.h"

@interface CMGroupInfoWireframe : NSObject

@property (nonatomic, weak) CMGroupInfoViewController *view;
@property (nonatomic, weak) CMGroupInfoPresenter *presenter;
@property (nonatomic, weak) CMGroupInfoInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

- (void)addToViewController:(UIViewController *)viewController;

- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end