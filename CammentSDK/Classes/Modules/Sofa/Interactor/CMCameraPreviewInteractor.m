//
// Created by Alexander Fedosov on 24/08/2018.
//

#import "CMCameraPreviewInteractor.h"
#import <Bolts/Bolts.h>
#import "SCRecorder.h"
#import "SCImageView.h"
#import "BFTask.h"


@interface CMCameraPreviewInteractor () <SCRecorderDelegate>
@end

@implementation CMCameraPreviewInteractor {

}


- (instancetype)init {
    self = [super init];

    if (self) {
        self.recorder = [SCRecorder recorder];
    }

    return self;
}

- (void)dealloc {
    self.recorder.SCImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureCamera {
    self.recorder.captureSessionPreset = AVCaptureSessionPresetHigh;
    self.recorder.device = AVCaptureDevicePositionFront;
    self.recorder.autoSetVideoOrientation = YES;
    self.recorder.supportedInterfaceOrientation = UIInterfaceOrientationMaskAll;
    self.recorder.delegate = self;

    SCVideoConfiguration *video = self.recorder.videoConfiguration;
    video.enabled = YES;
    video.size = CGSizeMake(270, 270);
    video.keepInputAffineTransform = YES;

    SCAudioConfiguration *audio = self.recorder.audioConfiguration;
    audio.enabled = YES;

    SCPhotoConfiguration *photo = self.recorder.photoConfiguration;
    photo.enabled = NO;
}

- (void)releaseCamera {
    [self.recorder stopRunning];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    self.recorder.SCImageView = view;
    self.recorder.mirrorOnFrontCamera = YES;

    NSError *error = nil;
    if (![self.recorder prepare:&error] || error) {
        DDLogDeveloperInfo(@"Coudn't configure video recorder %@", error);
        return;
    }

    if ([self.recorder.captureSession isRunning]) { return; }

    if (![self.recorder startRunning]) {
        NSLog(@"Something wrong there: %@", self.recorder.error);
        return;
    }
}

- (BFTask *)requestPermissionsForMediaTypeIfNeeded:(AVMediaType)mediaType {
    BFTaskCompletionSource *cameraPermission = [BFTaskCompletionSource new];

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    NSError *permissionDeniedError = [NSError errorWithDomain:CMSofaRecorderErrorDomain
                                                         code:0
                                                     userInfo:@{
                                                             @"mediaType" : mediaType
                                                     }];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        [cameraPermission setResult:mediaType];
    } else if(authStatus == AVAuthorizationStatusDenied){
        [cameraPermission setError:permissionDeniedError];
    } else if(authStatus == AVAuthorizationStatusRestricted){
        [cameraPermission setError:permissionDeniedError];
    } else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){
                [cameraPermission setResult:mediaType];
            } else {
                [cameraPermission setError:permissionDeniedError];
            }
        }];
    }

    return cameraPermission.task;
}

@end