//
//  CMInvitationCMInvitationWireframe.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMInvitationPresenter.h"
#import "CMInvitationInteractor.h"
#import "CMInvitationViewController.h"

@interface CMInvitationWireframe : NSObject

@property (nonatomic, weak) CMInvitationViewController *view;
@property (nonatomic, weak) CMInvitationPresenter *presenter;
@property (nonatomic, weak) CMInvitationInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

- (void)presentInWindow:(UIWindow *)window;
- (void)presentInViewController:(UIViewController *)viewController;
- (void)pushInNavigationController:(UINavigationController *)navigationController;

@end