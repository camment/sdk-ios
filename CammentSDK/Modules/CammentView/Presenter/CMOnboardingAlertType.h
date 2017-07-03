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