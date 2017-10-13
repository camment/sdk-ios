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
#import "CMInvitation.h"
#import "CMAnalytics.h"
#import "CMGroupsListInteractor.h"


NSString *kCMStoreCammentIdIfNotPlaying = @"";

@interface CMStore () <CMGroupsListInteractorOutput>
@property(nonatomic, strong) FBTweak *offlineTweak;
@property(nonatomic, strong) CMGroupsListInteractor *groupsListInteractor;
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
        self.isConnected = NO;
        self.isOnboardingFinished = [GVUserDefaults standardUserDefaults].isOnboardingFinished;
        self.reloadActiveGroupSubject = [RACSubject new];
        self.inviteFriendsActionSubject = [RACSubject new];

        self.groupsListInteractor = [CMGroupsListInteractor new];
        self.groupsListInteractor.output = self;

        [RACObserve(self, isOnboardingFinished) subscribeNext:^(NSNumber *value) {
            if (value.boolValue && ![GVUserDefaults standardUserDefaults].isOnboardingFinished) {
                [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventOnboardingEnd];
            }
            [GVUserDefaults standardUserDefaults].isOnboardingFinished = value.boolValue;
        }];

        [RACObserve(self, playingCammentId) subscribeNext:^(NSString *id) {
            if ([id isEqualToString:kCMStoreCammentIdIfNotPlaying]) { return; }
            [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventCammentPlay];
        }];

        NSArray *updateGroupsSignals = @[
                RACObserve(self, activeGroup),
                RACObserve(self, isConnected),
                RACObserve(self, isSignedIn),
        ];

        [[RACSignal combineLatest:updateGroupsSignals] subscribeNext:^(RACTuple *tuple) {
            [self.groupsListInteractor fetchUserGroups];
        }];
    }

    return self;
}

- (void)didFetchUserGroups:(NSArray *)groups {
    self.userGroups = groups;
}

- (void)didFailToFetchUserGroups:(NSError *)error {
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


@end
