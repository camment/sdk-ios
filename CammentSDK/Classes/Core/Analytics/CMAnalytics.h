//
// Created by Alexander Fedosov on 23.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kAnalyticsEventAppStart;
extern NSString *kAnalyticsEventShowsScreenList;
extern NSString *kAnalyticsEventShowScreen;
extern NSString *kAnalyticsEventInvite;
extern NSString *kAnalyticsEventOpenDeeplink;
extern NSString *kAnalyticsEventJoinGroup;
extern NSString *kAnalyticsEventRemovedFromGroup;
extern NSString *kAnalyticsEventAcceptJoinRequest;
extern NSString *kAnalyticsEventDeclineJoinRequest;
extern NSString *kAnalyticsEventFbSignin;
extern NSString *kAnalyticsEventCammentRecord;
extern NSString *kAnalyticsEventCammentPlay;
extern NSString *kAnalyticsEventCammentDelete;
extern NSString *kAnalyticsEventOnboardingStart;
extern NSString *kAnalyticsEventOnboardingEnd;

@interface CMAnalytics : NSObject

+ (CMAnalytics *)instance;

- (void)configureAWSMobileAnalytics;
- (void)configureMixpanelAnalytics;

- (void)setMixpanelID:(NSString *)id;
- (void)trackMixpanelEvent:(NSString *)event;
@end