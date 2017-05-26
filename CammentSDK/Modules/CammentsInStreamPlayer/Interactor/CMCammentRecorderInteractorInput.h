//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCImageView;

@protocol CMCammentRecorderInteractorInput <NSObject>

- (void)configureCamera;
- (void)releaseCamera;
- (void)startRecording;
- (void)stopRecording;
- (void)connectPreviewViewToRecorder:(SCImageView *)view;

@end