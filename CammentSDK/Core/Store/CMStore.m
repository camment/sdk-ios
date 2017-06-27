//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMStore.h"
#import "User.h"
#import "UsersGroup.h"


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
        }
    }

    return _instance;
}

@end
