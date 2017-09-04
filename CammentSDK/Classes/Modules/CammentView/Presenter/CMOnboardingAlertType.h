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
    CMOnboardingAlertSwipeDownToInviteFriendsTooltip,
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
    CMOnboardingAlertSwipeDownToInviteFriendsMaskTooltip = (1 << CMOnboardingAlertSwipeDownToInviteFriendsTooltip),
    CMOnboardingAlertTapAndHoldToDeleteCammentsMaskTooltip = (1 << CMOnboardingAlertTapAndHoldToDeleteCammentsTooltip),
    CMOnboardingAlertTapToPlayMaskCamment = (1 << CMOnboardingAlertTapToPlayCamment),
};