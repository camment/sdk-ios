//
//  CMShowsListCMShowsListWireframe.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMShowsListPresenter.h"
#import "CMShowsListInteractor.h"
#import "CMShowsListViewController.h"

@interface CMShowsListWireframe : NSObject

@property (nonatomic, weak) CMShowsListViewController *view;
@property (nonatomic, weak) CMShowsListPresenter *presenter;
@property (nonatomic, weak) CMShowsListInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

- (void)presentInWindow:(UIWindow *)window;
- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end