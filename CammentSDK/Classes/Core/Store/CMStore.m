//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStore.h"
#import "CMShow.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "FBTweakStore.h"
#import "FBTweakCollection.h"
#import "CMPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMAnalytics.h"
#import "CMGroupInfoInteractor.h"
#import "CMUserBuilder.h"
#import "CMAuthStatusChangedEventContext.h"
#import "CMGroupsListInteractor.h"
#import "CMUsersGroupBuilder.h"
#import "NSArray+RacSequence.h"
#import "CMCammentOverlayController.h"
#import "CMAppConfig.h"

NSString *kCMStoreCammentIdIfNotPlaying = @"";

@interface CMStore () <CMGroupInfoInteractorOutput>
@property(nonatomic, strong) FBTweak *offlineTweak;

@property(nonatomic, strong) CMGroupInfoInteractor *groupInfoInteractor;

@end

@implementation CMStore

+ (CMStore *)instance {
    static CMStore *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [CMStore new];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.playingCammentId = kCMStoreCammentIdIfNotPlaying;
        self.cammentRecordingState = CMCammentRecordingStateNotRecording;
        self.isOnboardingFinished = [GVUserDefaults standardUserDefaults].isOnboardingFinished;
        self.isOnboardingSkipped = [GVUserDefaults standardUserDefaults].isOnboardingSkipped;
        self.reloadActiveGroupSubject = [RACSubject new];
        self.inviteFriendsActionSubject = [RACSubject new];
        self.startTutorial = [RACSubject new];
        self.userHasJoinedSignal = [RACSubject new];
        self.cleanUpSignal = [RACSubject new];
        self.authentificationStatusSubject = [RACReplaySubject replaySubjectWithCapacity:1];
        self.serverMessagesSubject = [RACSubject new];
        self.fetchUpdatesSubject = [RACSubject new];
        self.requestPlayerStateFromHostAppSignal = [RACSubject new];

        self.groupInfoInteractor = [CMGroupInfoInteractor new];
        self.groupInfoInteractor.output = self;

        self.isOfflineMode = NO;
        self.awsServicesConfigured = NO;

        self.avoidTouchesInViews = @[];
        @weakify(self)
        [RACObserve(self, isOnboardingFinished) subscribeNext:^(NSNumber *value) {
            if (value.boolValue && ![GVUserDefaults standardUserDefaults].isOnboardingFinished) {
                [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventOnboardingEnd];
            }
            [GVUserDefaults standardUserDefaults].isOnboardingFinished = value.boolValue;
            [GVUserDefaults standardUserDefaults].isOnboardingSkipped = NO;
        }];

        [RACObserve(self, isOnboardingSkipped) subscribeNext:^(NSNumber *value) {
            [GVUserDefaults standardUserDefaults].isOnboardingSkipped = value.boolValue;
            if (value.boolValue) {
                [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventOnboardingSkip];
            }
        }];

        [RACObserve(self, playingCammentId) subscribeNext:^(NSString *id) {
            if ([id isEqualToString:kCMStoreCammentIdIfNotPlaying]) { return; }
            [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventCammentPlay];
        }];

        RACSignal *activeGroupUpdateSignal = [[[RACObserve(self, activeGroup)
                combinePreviousWithStart:self.activeGroup
                                  reduce:^id(CMUsersGroup *previous, CMUsersGroup *current) {
                                      return @([previous.uuid isEqualToString:current.uuid]);
                                  }]
                ignore:@(YES)]
                map:^id(id value) {
                    return self.activeGroup;
                }];

        NSArray *updateGroupsSignals = @[
                activeGroupUpdateSignal,
                self.userHasJoinedSignal,
                self.authentificationStatusSubject,
                RACObserve(self, awsServicesConfigured),
        ];

        [[RACSignal combineLatest:updateGroupsSignals] subscribeNext:^(RACTuple *tuple) {
            CMUsersGroup *group = tuple.first;
            CMAuthStatusChangedEventContext *statusChangedEventContext = tuple.third;
            NSNumber *sdkConfigured = tuple.fourth;

            if (statusChangedEventContext.state == CMCammentUserNotAuthentificated || !sdkConfigured.boolValue) {
                return;
            }

            if (group && group.uuid) {
                self.isFetchingGroupUsers = YES;
                [self.groupInfoInteractor fetchUsersInGroup:group.uuid];
                [self.groupInfoInteractor setActiveGroup:group.uuid];
            } else {
                [self.groupInfoInteractor unsetActiveGroup];
            }
        }];
        
        [self.userHasJoinedSignal sendNext:@YES];
    }

    return self;
}

- (void)setupTweaks {
    FBTweakStore *store = [FBTweakStore sharedInstance];

    FBTweakCategory *presentationCategory = [store tweakCategoryWithName:@"Predefined stuff"];
    if (!presentationCategory) {
        presentationCategory = [[FBTweakCategory alloc] initWithName:@"Predefined stuff"];
        [store addTweakCategory:presentationCategory];
    }

    FBTweakCollection *presentationsCollection = [presentationCategory tweakCollectionWithName:@"Demo"];
    if (!presentationsCollection) {
        presentationsCollection = [[FBTweakCollection alloc] initWithName:@"Demo"];
        [presentationCategory addTweakCollection:presentationsCollection];
    }

    NSArray<id <CMPresentationBuilder>> *presentations = [CMPresentationUtility activePresentations];

    FBTweak *showTweak = [presentationsCollection tweakWithIdentifier:@"Scenario"];
    if (!showTweak) {
        showTweak = [[FBTweak alloc] initWithIdentifier:@"Scenario"];
        showTweak.possibleValues = [@[@"None"] arrayByAddingObjectsFromArray:[presentations.rac_sequence map:^id(id <CMPresentationBuilder> value) {
            return [value presentationName];
        }].array];
        showTweak.defaultValue = @"None";
        showTweak.name = @"Choose demo scenario";
        [presentationsCollection addTweak:showTweak];
    }

    for (id <CMPresentationBuilder> presentation in presentations) {
        [presentation configureTweaks:presentationCategory];
    }

    FBTweakCollection *webSettingCollection = [presentationCategory tweakCollectionWithName:@"Web settings"];
    if (!webSettingCollection) {
        webSettingCollection = [[FBTweakCollection alloc] initWithName:@"Web settings"];
        [presentationCategory addTweakCollection:webSettingCollection];
    }

    NSString *tweakName = @"Web page url";
    FBTweak *cammentDelayTweak = [webSettingCollection tweakWithIdentifier:tweakName];
    if (!cammentDelayTweak) {
        cammentDelayTweak = [[FBTweak alloc] initWithIdentifier:tweakName];
        cammentDelayTweak.defaultValue = @"http://aftonbladet.se";
        cammentDelayTweak.currentValue = @"http://aftonbladet.se";
        cammentDelayTweak.name = tweakName;
        [webSettingCollection addTweak:cammentDelayTweak];
    }

    FBTweakCategory *settingsCategory = [store tweakCategoryWithName:@"Settings"];
    if (!settingsCategory) {
        settingsCategory = [[FBTweakCategory alloc] initWithName:@"Settings"];
        [store addTweakCategory:settingsCategory];
    }

    FBTweakCollection *videoSettingsCollection = [presentationCategory tweakCollectionWithName:@"Video player settings"];
    if (!videoSettingsCollection) {
        videoSettingsCollection = [[FBTweakCollection alloc] initWithName:@"Video player settings"];
        [settingsCategory addTweakCollection:videoSettingsCollection];
    }

    FBTweak *volumeTweak = [videoSettingsCollection tweakWithIdentifier:@"Volume"];
    if (!volumeTweak) {
        volumeTweak = [[FBTweak alloc] initWithIdentifier:@"Volume"];
        volumeTweak.minimumValue = @.0f;
        volumeTweak.stepValue = @10.0f;
        volumeTweak.maximumValue = @100.0f;
        volumeTweak.defaultValue = @30.0f;
        volumeTweak.name = @"Volume (%)";
        [videoSettingsCollection addTweak:volumeTweak];
    }

    FBTweakCollection *appSettingsCollection = [presentationCategory tweakCollectionWithName:@"General"];
    if (!appSettingsCollection) {
        appSettingsCollection = [[FBTweakCollection alloc] initWithName:@"General"];
        [settingsCategory addTweakCollection:appSettingsCollection];
    }

    self.offlineTweak = [appSettingsCollection tweakWithIdentifier:@"Offline"];
    if (!self.offlineTweak) {
        self.offlineTweak = [[FBTweak alloc] initWithIdentifier:@"Offline"];
        self.offlineTweak.defaultValue = @NO;
        self.offlineTweak.name = @"Offline mode";
        [appSettingsCollection addTweak:self.offlineTweak];
    }

    self.isOfflineMode = [self.offlineTweak.currentValue boolValue];
    [self.offlineTweak addObserver:self];
    DDLogInfo(@"Tweaks have been configured");
}

- (void)tweakDidChange:(FBTweak *)tweak {
    NSLog(@"%@", tweak.currentValue);
    if ([tweak.identifier isEqual:self.offlineTweak.identifier]) {
        self.isOfflineMode = [tweak.currentValue boolValue];
    }
}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFailToFetchUsersInGroup:(NSError *)group {
    self.isFetchingGroupUsers = NO;
}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFetchUsers:(NSArray<CMUser *> *)users inGroup:(NSString *)group {
    if ([group isEqualToString:self.activeGroup.uuid]) {
        self.activeGroupUsers = users;
    }
    self.isFetchingGroupUsers = NO;
}

- (void)cleanUp {
    [self.cleanUpSignal sendNext:@YES];

    self.playingCammentId = kCMStoreCammentIdIfNotPlaying;
    self.cammentRecordingState = CMCammentRecordingStateNotRecording;

    self.activeGroup = nil;
    self.activeGroupUsers = @[];

    self.isOnboardingFinished = YES;
}

- (void)updateUserDataOnIdentityChangeOldIdentity:(NSString *)oldIdentity newIdentity:(NSString *)newIdentity {
    if ([[self.activeGroup ownerCognitoUserId] isEqualToString:oldIdentity]) {
        [CMStore instance].activeGroup = [[[CMUsersGroupBuilder
                usersGroupFromExistingUsersGroup:[CMStore instance].activeGroup]
                withOwnerCognitoUserId:newIdentity]
                build];
    }

    self.activeGroupUsers = [self.activeGroupUsers map:^CMUser *(CMUser *oldUser) {
        if ([[oldUser cognitoUserId] isEqualToString:oldIdentity]) {
            return [[[CMUserBuilder userFromExistingUser:oldUser]
                    withCognitoUserId:newIdentity]
                    build];
        }

        return oldUser;
    }];

    DDLogInfo(@"User data have been updated of uuid sync");
}

- (void)cleanUpCurrentChatGroup {
    self.activeGroup = nil;
    self.activeGroupUsers = @[];
    [[self reloadActiveGroupSubject] sendNext:@YES];
}

- (void)refetchUsersInActiveGroup {
    if (self.activeGroup && self.activeGroup.uuid) {
        [self.groupInfoInteractor fetchUsersInGroup:self.activeGroup.uuid];
    }
}

- (void)setAvoidTouchesInViews:(NSArray *)avoidTouchesInViews {
    _avoidTouchesInViews = avoidTouchesInViews;
    
}

@end
