//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kCMStoreCammentIdIfNotPlaying;

@interface CMStore: NSObject

@property (nonatomic, assign) BOOL isSignedIn;

@property (nonatomic, copy) NSString *playingCammentId;
@property (nonatomic, assign) BOOL isRecordingCamment;

+ (CMStore *)instance;

@end
