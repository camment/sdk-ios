//
//  CMCammentViewCMCammentViewPresenterInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CMOnboardingAlertType.h"

@class SCImageView;

@protocol CMCammentViewPresenterInput <NSObject>

- (void)setupView;
- (void)connectPreviewViewToRecorder:(SCImageView *)view;
- (UIInterfaceOrientationMask)contentPossibleOrientationMask;
- (void)inviteFriendsAction;

- (void)updateCameraOrientation:(AVCaptureVideoOrientation)orientation;

- (void)completeActionForOnboardingAlert:(CMOnboardingAlertType)type;
- (void)cancelActionForOnboardingAlert:(CMOnboardingAlertType)type;

- (void)readyToShowOnboarding;

- (CMOnboardingAlertType)currentOnboardingStep;

- (void)checkIfNeedForOnboarding;

- (void)setupCameraSession;
@end
