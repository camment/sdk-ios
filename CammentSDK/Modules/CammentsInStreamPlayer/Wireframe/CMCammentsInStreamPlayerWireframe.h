//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerWireframe.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMCammentsInStreamPlayerPresenter.h"
#import "CMCammentsLoaderInteractor.h"
#import "CMCammentsInStreamPlayerViewController.h"

@class Show;

@interface CMCammentsInStreamPlayerWireframe : NSObject

@property (nonatomic, strong) Show *show;

@property (nonatomic, weak) CMCammentsInStreamPlayerViewController *view;
@property (nonatomic, weak) CMCammentsInStreamPlayerPresenter *presenter;
@property (nonatomic, weak) CMCammentsLoaderInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

- (void)presentInWindow:(UIWindow *)window;

- (instancetype)initWithShow:(Show *)show;

- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end