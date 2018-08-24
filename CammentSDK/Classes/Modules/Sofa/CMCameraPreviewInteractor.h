//
// Created by Alexander Fedosov on 24/08/2018.
//

#import <Foundation/Foundation.h>

@class SCRecorder;
@class SCImageView;


@interface CMCameraPreviewInteractor : NSObject

@property (nonatomic, strong) SCRecorder *recorder;

- (void)configureCamera;

- (void)releaseCamera;

- (void)connectPreviewViewToRecorder:(SCImageView *)view;
@end