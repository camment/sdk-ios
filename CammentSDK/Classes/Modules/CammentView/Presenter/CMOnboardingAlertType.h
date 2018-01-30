//
//  CMOnboardingAlertType.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CMOnboardingAlertType) {
    CMOnboardingAlertNone,
    CMOnboardingAlertWouldYouLikeToChatAlert,
    CMOnboardingAlertWhatIsCammentTooltip,
    CMOnboardingAlertTapAndHoldToRecordTooltip,
    CMOnboardingAlertSwipeLeftToHideCammentsTooltip,
    CMOnboardingAlertSwipeRightToShowCammentsTooltip,
    CMOnboardingAlertPullRightToInviteFriendsTooltip,
    CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip,
    CMOnboardingAlertTapToPlayCamment,
    CMOnboardingAlertPostponedOnboardingReminder,
};

FOUNDATION_EXPORT const struct CMOnboardingState {
    __unsafe_unretained NSString *NotStarted;
    __unsafe_unretained NSString *Finished;
    __unsafe_unretained NSString *WouldYouLikeToChatAlert;
    __unsafe_unretained NSString *TapAndHoldToRecordCamment;
    __unsafe_unretained NSString *SwipeLeftToHideCamments;
    __unsafe_unretained NSString *SwipeRightToShowCamments;
    __unsafe_unretained NSString *PullRightToInviteFriends;
    __unsafe_unretained NSString *TapAndHoldToDeleteCamment;
    __unsafe_unretained NSString *TapToPlayCamment;
    __unsafe_unretained NSString *PostponedReminder;
    __unsafe_unretained NSString *SkippedReminder;
} CMOnboardingState;

FOUNDATION_EXPORT const struct CMOnboardingEvent {
    __unsafe_unretained NSString *Started;
    __unsafe_unretained NSString *CammentRecorded;
    __unsafe_unretained NSString *CammentBlockSwipedLeft;
    __unsafe_unretained NSString *CammentBlockSwipedRight;
    __unsafe_unretained NSString *GroupInfoSidebarOpened;
    __unsafe_unretained NSString *CammentDeleted;
    __unsafe_unretained NSString *CammentPlayed;
    __unsafe_unretained NSString *OnboardingPostponed;
    __unsafe_unretained NSString *OnboardingSkipped;
} CMOnboardingEvent;