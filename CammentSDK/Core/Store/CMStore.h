//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "CMUser.h"
#import "CMUsersGroup.h"

@class CMShow;
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

@property (nonatomic, copy) CMUsersGroup *activeGroup;

@property(nonatomic, copy) NSString *cognitoUserId;

@property(nonatomic) BOOL isOnboardingFinished;

@property(nonatomic) CMShowMetadata *currentShowMetadata;

@property(nonatomic, strong) CMUser *currentUser;

@property(nonatomic, copy) NSString *facebookUserId;

@property(nonatomic, copy) NSString *apiKey;

@property(nonatomic, copy) NSString *email;

@property RACSubject<NSNumber *> *reloadActiveGroupSubject;

+ (CMStore *)instance;

@end
