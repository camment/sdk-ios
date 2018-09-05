//
// Created by Alexander Fedosov on 24/08/2018.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString *const CMSofaRecorderErrorDomain = @"CMSofaRecorderErrorDamain";
@class SCRecorder;
@class SCImageView;
@class BFTask;


@interface CMCameraPreviewInteractor : NSObject

@property (nonatomic, strong) SCRecorder *recorder;

- (void)configureCamera;

- (void)releaseCamera;

- (void)connectPreviewViewToRecorder:(SCImageView *)view;

- (BFTask *)requestPermissionsForMediaTypeIfNeeded:(AVMediaType)mediaType;
@end