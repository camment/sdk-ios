//
//  CMGroupsListCMGroupsListWireframe.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMGroupsListPresenter.h"
#import "CMGroupsListInteractor.h"
#import "CMGroupsListViewController.h"

@interface CMGroupsListWireframe : NSObject

@property (nonatomic, weak) CMGroupsListViewController *view;
@property (nonatomic, weak) CMGroupsListPresenter *presenter;
@property (nonatomic, weak) CMGroupsListInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

- (void)presentInWindow:(UIWindow *)window;
- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end