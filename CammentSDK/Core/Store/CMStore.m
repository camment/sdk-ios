//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStore.h"
#import "Show.h"
#import "GVUserDefaults+CammentSDKConfig.h"


NSString *kCMStoreCammentIdIfNotPlaying = @"";

@implementation CMStore

+ (CMStore *)instance {
    static CMStore *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.playingCammentId = kCMStoreCammentIdIfNotPlaying;
            _instance.cammentRecordingState = CMCammentRecordingStateNotRecording;
            _instance.isConnected = NO;
            _instance.isOnboardingFinished = [GVUserDefaults standardUserDefaults].isOnboardingFinished;

            [RACObserve(_instance, isOnboardingFinished) subscribeNext:^(NSNumber *value) {
                [GVUserDefaults standardUserDefaults].isOnboardingFinished = value.boolValue;
            }];
        }
    }

    return _instance;
}

@end
