//
//  CMCammentViewCMCammentViewWireframe.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMCammentViewPresenter.h"
#import "CMCammentViewInteractor.h"
#import "CMCammentViewController.h"

@class CMShowMetadata;

@interface CMCammentViewWireframe : NSObject

@property (nonatomic, weak) CMCammentViewController *view;
@property (nonatomic, weak) CMCammentViewPresenter *presenter;
@property (nonatomic, weak) CMCammentViewInteractor *interactor;

@property (nonatomic, weak) UIViewController *parentViewController;
@property (nonatomic, weak) UINavigationController *parentNavigationController;

@property(nonatomic, strong) CMShowMetadata *metadata;

@property(nonatomic, strong) CMCammentOverlayLayoutConfig *overlayLayoutConfig;

- (instancetype)initWithShowMetadata:(CMShowMetadata *)metadata
                 overlayLayoutConfig:(CMCammentOverlayLayoutConfig *)overlayLayoutConfig NS_DESIGNATED_INITIALIZER;

- (CMCammentViewController *)controller;

@end