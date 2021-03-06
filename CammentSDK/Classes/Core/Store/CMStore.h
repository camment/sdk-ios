//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMUser.h"
#import "CMUsersGroup.h"
#import <Tweaks/FBTweak.h>
#import "CMIdentityProvider.h"

@class CMShow;
@class CMShowMetadata;
@class CMInvitation;
@class CMCammentOverlayLayoutConfig;
@class CMAuthStatusChangedEventContext;
@class CMServerMessage;
@protocol CMCammentOverlayControllerDelegate;
@class CMAppConfig;

extern NSString *kCMStoreCammentIdIfNotPlaying;

typedef NS_ENUM(NSInteger, CMCammentRecordingState) {
    CMCammentRecordingStateNotRecording,
    CMCammentRecordingStateRecording,
    CMCammentRecordingStateFinished,
    CMCammentRecordingStateCancelled
};

@interface CMStore: NSObject <FBTweakObserver>

@property (nonatomic, strong) CMAppConfig *appConfig;

@property (nonatomic, assign) NSTimeInterval currentShowTimeInterval;
@property (nonatomic, copy) NSString *playingCammentId;

@property (nonatomic, assign) CMCammentRecordingState cammentRecordingState;

@property (nonatomic, copy) CMUsersGroup *activeGroup;
@property (nonatomic, strong) NSArray<CMUser *> *activeGroupUsers;

@property(nonatomic) BOOL isOnboardingFinished;
@property(nonatomic) BOOL isOnboardingSkipped;
@property(nonatomic) BOOL isFetchingGroupUsers;
@property(nonatomic) BOOL isFetchingGroupList;

@property(nonatomic) CMShowMetadata *currentShowMetadata;

@property RACSubject<CMAuthStatusChangedEventContext *> *authentificationStatusSubject;
@property RACSubject<CMServerMessage *> *serverMessagesSubject;

@property RACSubject<NSNumber *> *reloadActiveGroupSubject;
@property RACSubject<NSNumber *> *inviteFriendsActionSubject;
@property RACSubject<NSNumber *> *startTutorial;
@property RACSubject<NSNumber *> *userHasJoinedSignal;
@property RACSubject<NSNumber *> *cleanUpSignal;
@property RACSubject<NSNumber *> *fetchUpdatesSubject;
@property RACSubject<NSNumber *> *requestPlayerStateFromHostAppSignal;

@property(nonatomic) BOOL isOfflineMode;
@property(nonatomic) BOOL awsServicesConfigured;

@property(nonatomic, strong) NSArray *avoidTouchesInViews;

@property(nonatomic) BOOL connectionAvailable;

@property(nonatomic, strong) NSDate *lastTimestampUploaded;

@property(nonatomic, weak) id <CMCammentOverlayControllerDelegate> overlayDelegate;

@property(nonatomic) BOOL shoudForceSynced;

@property(nonatomic) NSTimeInterval showTimestamp;

+ (CMStore *)instance;

- (void)setupTweaks;

- (void)cleanUp;

- (void)updateUserDataOnIdentityChangeOldIdentity:(NSString *)oldIdentity newIdentity:(NSString *)newIdentity;

- (void)cleanUpCurrentChatGroup;

- (void)refetchUsersInActiveGroup;

@end
