//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <SCRecorder/SCRecorder.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentRecorderInteractor.h"
#import "CMCammentRecorderInteractorOutput.h"
#import "CMStore.h"
#import "CMAutoFrameFilter.h"


@interface CMCammentRecorderInteractor () <SCRecorderDelegate>
@property(nonatomic, weak) SCImageView *previewView;
@end

@implementation CMCammentRecorderInteractor {
    SCRecorder *recorder;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        recorder = [SCRecorder recorder];
        [RACObserve([CMStore instance], isRecordingCamment) subscribeNext:^(NSNumber *isRecording) {
            [recorder setSCImageView:isRecording.boolValue ? _previewView : nil];
        }];
    }

    return self;
}

- (void) configureCamera {
    recorder.captureSessionPreset = AVCaptureSessionPresetHigh;
    recorder.device = AVCaptureDevicePositionFront;
    recorder.autoSetVideoOrientation = YES;
    recorder.delegate = self;
    recorder.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
    // Get the video configuration object
    SCVideoConfiguration *video = recorder.videoConfiguration;
    video.enabled = YES;
    video.size = CGSizeMake(270, 270);
    video.keepInputAffineTransform = YES;

    // Get the audio configuration object
    SCAudioConfiguration *audio = recorder.audioConfiguration;
    audio.enabled = YES;

    SCPhotoConfiguration *photo = recorder.photoConfiguration;
    photo.enabled = NO;
}

- (void)releaseCamera {
    [recorder stopRunning];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    self.previewView = view;
    [(SCFilterImageView *)view setFilter:recorder.videoConfiguration.filter];
    recorder.mirrorOnFrontCamera = YES;

    if (![recorder startRunning]) {
        NSLog(@"Something wrong there: %@", recorder.error);
    }

    recorder.session = [SCRecordSession recordSession];
}

- (void)startRecording {
    if (recorder.isRecording) {return;}
    [recorder.session removeAllSegments];
    [recorder record];
}

- (void)stopRecording {
    [recorder pause];
}

- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSegment:(SCRecordSessionSegment *__nullable)segment inSession:(SCRecordSession *__nonnull)session error:(NSError *__nullable)error {
    [self.output recorderDidFinishAVAsset:[recorder.session assetRepresentingSegments]];

    AVAsset *asset = session.assetRepresentingSegments;
    SCAssetExportSession *assetExportSession = [[SCAssetExportSession alloc] initWithAsset:asset];
    assetExportSession.outputUrl = recorder.session.outputUrl;
    assetExportSession.outputFileType = AVFileTypeMPEG4;

    assetExportSession.videoConfiguration.filter = [CMAutoFrameFilter new];
    assetExportSession.videoConfiguration.preset = SCPresetMediumQuality;
    assetExportSession.audioConfiguration.preset = SCPresetLowQuality;
    [assetExportSession exportAsynchronouslyWithCompletionHandler: ^{
        if (assetExportSession.error == nil) {
            [self.output recorderDidFinishExportingToURL:recorder.session.outputUrl];
        } else {
            // Something bad happened
        }
    }];
}

@end