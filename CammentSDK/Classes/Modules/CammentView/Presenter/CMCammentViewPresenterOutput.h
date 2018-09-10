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

- (void)askForSetupPermissions;

- (void)presentCammentOptionsView:(CMCammentCell *)camment actions:(CMCammentActionsMask)actions;

- (void)presentViewController:(UIViewController *)controller;

- (void)playAdVideo:(CMVideoAd *)videoAd startingFromRect:(CGRect)startsRect;

- (void)showAllowCameraPermissionsView;

- (void)setDisableHiddingCammentBlock:(BOOL)disableHiddingCammentBlock;

- (void)closeSidebarIfOpened:(void (^)())completion;
@end


@protocol CMOnboardingInteractorOutput <NSObject>

- (void)showOnboardingAlert:(CMOnboardingAlertType)type;
- (void)hideOnboardingAlert:(CMOnboardingAlertType)type;

- (void)updateContinueTutorialButtonState;
- (void)showSkipTutorialButton;

- (void)hideSkipTutorialButton:(BOOL)onboardingFinished;

@end