//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "SCRecorder.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentRecorderInteractor.h"
#import "CMCammentRecorderInteractorOutput.h"
#import "CMStore.h"
#import "CMAutoFrameFilter.h"


@interface CMCammentRecorderInteractor () <SCRecorderDelegate>

@property (nonatomic, strong) SCRecorder *recorder;
@property (nonatomic, assign) BOOL permissionsDenied;

@end

@implementation CMCammentRecorderInteractor

- (instancetype)init {
    self = [super init];

    if (self) {
        self.recorder = [SCRecorder recorder];
    }

    return self;
}

- (void)dealloc {
    self.recorder.SCImageView = nil;
}

- (void)configureCamera {
    self.recorder.captureSessionPreset = AVCaptureSessionPresetHigh;
    self.recorder.device = AVCaptureDevicePositionFront;
    self.recorder.autoSetVideoOrientation = NO;
    self.recorder.delegate = self;
    // Get the video configuration object
    SCVideoConfiguration *video = self.recorder.videoConfiguration;
    video.enabled = YES;
    video.size = CGSizeMake(270, 270);
    video.keepInputAffineTransform = YES;
    // Get the audio configuration object
    SCAudioConfiguration *audio = self.recorder.audioConfiguration;
    audio.enabled = YES;

    SCPhotoConfiguration *photo = self.recorder.photoConfiguration;
    photo.enabled = NO;
}

- (void)updateDeviceOrientation:(AVCaptureVideoOrientation)orientation {
    [self.recorder setVideoOrientation:orientation];
}

- (void)releaseCamera {
    [self.recorder stopRunning];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    self.recorder.SCImageView = view;
    self.recorder.mirrorOnFrontCamera = YES;

    if (![self.recorder startRunning]) {
        NSLog(@"Something wrong there: %@", self.recorder.error);
    }

    self.recorder.session = [SCRecordSession recordSession];
}

- (void)checkCameraAndMicrophonePermissions {

    AVAuthorizationStatus cameraPermissions = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus microphonePermissions = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];

    BOOL cameraDenied = cameraPermissions == AVAuthorizationStatusDenied || cameraPermissions == AVAuthorizationStatusRestricted;
    BOOL microphoneDenied = microphonePermissions == AVAuthorizationStatusDenied || microphonePermissions == AVAuthorizationStatusRestricted;

    self.permissionsDenied = cameraDenied || microphoneDenied;

    if (self.permissionsDenied) {
        [self.output recorderNoticedDeniedCameraOrMicrophonePermission];
    }
}

- (void)startRecording {
    [self checkCameraAndMicrophonePermissions];
    if (self.recorder.isRecording || self.permissionsDenied) { return; }
    [self.recorder.session removeAllSegments];
    [self.recorder record];
}

- (void)stopRecording {
    [self.recorder pause];
}

- (void)cancelRecording {
    SCRecordSession *recordSession = self.recorder.session;

    if (recordSession != nil) {
        [recordSession removeAllSegments];
        self.recorder.session = nil;
        [recordSession cancelSession:nil];
        [self.recorder pause];
        self.recorder.session = [SCRecordSession recordSession];
    }
}

- (void)recorder:(SCRecorder *__nonnull)_recorder didCompleteSegment:(SCRecordSessionSegment *__nullable)segment inSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error {
    NSString *assetKey = [[NSUUID new].UUIDString lowercaseString];
    [self.output recorderDidFinishAVAsset:[_recorder.session assetRepresentingSegments] uuid:assetKey];

    AVAsset *asset = session.assetRepresentingSegments;
    SCAssetExportSession *assetExportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
    assetExportSession.outputUrl = _recorder.session.outputUrl;
    assetExportSession.outputFileType = AVFileTypeMPEG4;

    assetExportSession.videoConfiguration.preset = SCPresetMediumQuality;
    assetExportSession.audioConfiguration.preset = SCPresetLowQuality;
    __weak typeof(self) weakSelf = self;
    [assetExportSession exportAsynchronouslyWithCompletionHandler: ^{
        if (assetExportSession.error == nil) {
            [weakSelf.output recorderDidFinishExportingToURL:_recorder.session.outputUrl uuid:assetKey];
        } else {
            // Something bad happened
        }
    }];
}

@end
