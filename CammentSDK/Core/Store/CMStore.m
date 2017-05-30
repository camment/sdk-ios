//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMStore.h"


NSString *kCMStoreCammentIdIfNotPlaying = @"";

@implementation CMStore

+ (CMStore *)instance {
    static CMStore *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
            _instance.playingCammentId = kCMStoreCammentIdIfNotPlaying;
        }
    }

    return _instance;
}

@end
