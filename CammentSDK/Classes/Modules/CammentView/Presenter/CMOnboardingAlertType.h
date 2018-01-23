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
};

typedef NS_OPTIONS(NSUInteger, CMOnboardingAlertMaskType) {
    CMOnboardingAlertMaskNone = (1 << CMOnboardingAlertNone),
    CMOnboardingAlertWouldYouLikeToChatMaskAlert = (1 << CMOnboardingAlertWouldYouLikeToChatAlert),
    CMOnboardingAlertWhatIsCammentMaskTooltip = (1 << CMOnboardingAlertWhatIsCammentTooltip),
    CMOnboardingAlertTapAndHoldToRecordMaskTooltip = (1 << CMOnboardingAlertTapAndHoldToRecordTooltip),
    CMOnboardingAlertSwipeLeftToHideCammentsMaskTooltip = (1 << CMOnboardingAlertSwipeLeftToHideCammentsTooltip),
    CMOnboardingAlertSwipeRightToShowCammentsMaskTooltip = (1 << CMOnboardingAlertSwipeRightToShowCammentsTooltip),
    CMOnboardingAlertPullRightToInviteFriendsMaskTooltip = (1 << CMOnboardingAlertPullRightToInviteFriendsTooltip),
    CMOnboardingAlertTapAndHoldToDeleteCammentsMaskTooltip = (1 << CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip),
    CMOnboardingAlertTapToPlayMaskCamment = (1 << CMOnboardingAlertTapToPlayCamment),
};