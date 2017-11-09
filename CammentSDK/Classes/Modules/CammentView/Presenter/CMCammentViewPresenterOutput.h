//
//  CMCammentViewCMCammentViewPresenterOutput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMOnboardingAlertType.h"

@class CMUserJoinedMessage;
@class CMCamment;
@protocol CMCammentsBlockDelegate;
@class CMCammentCell;
@class CMVideoAd;

typedef NS_OPTIONS(NSInteger, CMCammentActionsMask) {
    CMCammentActionsMaskNone,
    CMCammentActionsMaskDelete
};

@protocol CMCammentViewPresenterOutput <NSObject>

- (void)setCammentsBlockNodeDelegate:(id<CMCammentsBlockDelegate>)delegate;
- (void)presenterDidRequestViewPreviewView;

- (void)showOnboardingAlert:(CMOnboardingAlertType)type;
- (void)hideOnboardingAlert:(CMOnboardingAlertType)type;

- (void)askForSetupPermissions;

- (void)presentCammentOptionsView:(CMCammentCell *)camment actions:(CMCammentActionsMask)actions;

- (void)presentUserJoinedMessage:(CMUserJoinedMessage *)message;

- (void)presentViewController:(UIViewController *)controller;

- (void)playAdVideo:(CMVideoAd *)videoAd startingFromRect:(CGRect)startsRect;

- (void)showAllowCameraPermissionsView;
@end
