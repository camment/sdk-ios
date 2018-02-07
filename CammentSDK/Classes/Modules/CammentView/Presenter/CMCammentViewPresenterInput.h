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
@class CMCamment;

@protocol CMCammentViewPresenterInput <NSObject>

- (void)setupView;
- (void)connectPreviewViewToRecorder:(SCImageView *)view;
- (UIInterfaceOrientationMask)contentPossibleOrientationMask;
- (void)inviteFriendsAction;

- (void)updateCameraOrientation:(AVCaptureVideoOrientation)orientation;

- (void)readyToShowOnboarding;

- (void)checkIfNeedForOnboarding;

- (void)setupCameraSession;

- (void)deleteCammentAction:(CMCamment *)camment;

- (BOOL)isCameraSessionConfigured;

@end

@protocol CMOnboardingInteractorInput <NSObject>

- (void)sendOnboardingEvent:(NSString *)event;

@end