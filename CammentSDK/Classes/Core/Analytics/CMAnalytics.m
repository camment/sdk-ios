//
// Created by Alexander Fedosov on 23.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSCore/AWSCore.h>
#import <AWSMobileAnalytics/AWSMobileAnalytics.h>
#import "CMAnalytics.h"
#import "Mixpanel.h"
#import "MixpanelPrivate.h"

NSString *kAnalyticsEventAppStart = @"App Start";
NSString *kAnalyticsEventShowsScreenList = @"Shows List Screen";
NSString *kAnalyticsEventShowScreen = @"Show Screen";
NSString *kAnalyticsEventInvite = @"Invite to Group";
NSString *kAnalyticsEventOpenDeeplink = @"Open Deeplink";
NSString *kAnalyticsEventJoinGroup = @"Join Group";
NSString *kAnalyticsEventAcceptJoinRequest = @"Accept Join Request";
NSString *kAnalyticsEventDeclineJoinRequest = @"Decline Join Request";
NSString *kAnalyticsEventFbSignin = @"FB SignIn";
NSString *kAnalyticsEventCammentRecord = @"Record Camment";
NSString *kAnalyticsEventCammentPlay = @"Play Camment";
NSString *kAnalyticsEventCammentDelete = @"Delete Camment";
NSString *kAnalyticsEventOnboardingStart = @"Onboarding Start";
NSString *kAnalyticsEventOnboardingEnd = @"Onboarding End";

@interface CMAnalytics ()
@property(nonatomic, strong) AWSMobileAnalytics *analytics;
@property(nonatomic, strong) Mixpanel *mixpanel;
@end

@implementation CMAnalytics

+ (CMAnalytics *)instance {
    static CMAnalytics *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)configureAWSMobileAnalytics {
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
            initWithRegionType: AWSRegionUSEast1
                identityPoolId: @"us-east-1:71549a59-04b7-4924-9973-0c35c9278e78"];
    AWSServiceConfiguration *serviceConfiguration = [[AWSServiceConfiguration alloc]
            initWithRegion: AWSRegionUSEast1
       credentialsProvider: credentialsProvider];
    AWSMobileAnalyticsConfiguration *analyticsConfiguration = [[AWSMobileAnalyticsConfiguration alloc] init];
    [analyticsConfiguration setServiceConfiguration:serviceConfiguration];
    self.analytics = [AWSMobileAnalytics
            mobileAnalyticsForAppId: @"ea4151c5b77046bfb7213de5d02f514f" 
                      configuration: analyticsConfiguration];
}

- (void)configureMixpanelAnalytics {
    self.mixpanel = [Mixpanel sharedInstanceWithToken:@"6231cfc8ae03c78928c045c7cb9853b3"];
}

- (void)setMixpanelID:(NSString *)id {
    [self.mixpanel setDistinctId:id];
}

- (void)trackMixpanelEvent:(NSString *)event {
    [self.mixpanel track:event];
}


@end