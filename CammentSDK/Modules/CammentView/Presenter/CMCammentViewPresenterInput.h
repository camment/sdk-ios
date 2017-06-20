//
//  CMCammentViewCMCammentViewPresenterInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SCImageView;

@protocol CMCammentViewPresenterInput <NSObject>

- (void)setupView;
- (void)connectPreviewViewToRecorder:(SCImageView *)view;
- (UIInterfaceOrientationMask)contentPossibleOrientationMask;
- (void)inviteFriendsAction;

- (void)updateCameraOrientation:(enum AVCaptureVideoOrientation)orientation;
@end