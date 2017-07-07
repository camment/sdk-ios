//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UsersGroup.h"

@class Show;
@class CMShowMetadata;

extern NSString *kCMStoreCammentIdIfNotPlaying;

typedef NS_ENUM(NSInteger, CMCammentRecordingState) {
    CMCammentRecordingStateNotRecording,
    CMCammentRecordingStateRecording,
    CMCammentRecordingStateFinished,
    CMCammentRecordingStateCancelled
};
@interface CMStore: NSObject

@property (nonatomic, assign) BOOL isSignedIn;
@property (nonatomic, assign) BOOL isFBConnected;
@property (nonatomic, assign) BOOL isConnected;

@property (nonatomic, assign) NSTimeInterval currentShowTimeInterval;
@property (nonatomic, copy) NSString *playingCammentId;

@property (nonatomic, assign) CMCammentRecordingState cammentRecordingState;

@property (nonatomic, copy) UsersGroup *activeGroup;

@property(nonatomic, copy) NSString *cognitoUserId;

@property(nonatomic) BOOL isOnboardingFinished;

@property(nonatomic) CMShowMetadata *currentShowMetadata;

@property(nonatomic, strong) User *currentUser;

@property(nonatomic, copy) NSString *facebookUserId;

@property(nonatomic, copy) NSString *apiKey;

+ (CMStore *)instance;

@end
