#import "CMOnboardingAlertType.h"

const struct CMOnboardingState CMOnboardingState = {
        .NotStarted = @"NotStarted",
        .Finished = @"Finished",
        .WouldYouLikeToChatAlert = @"WouldYouLikeToChatAlert",
        .TapAndHoldToRecordCamment = @"TapAndHoldToRecordCamment",
        .SwipeLeftToHideCamments = @"SwipeLeftToHideCamments",
        .SwipeRightToShowCamments = @"SwipeRightToShowCamments",
        .PullRightToInviteFriends = @"PullRightToInviteFriends",
        .TapAndHoldToDeleteCamment = @"TapAndHoldToDeleteCamment",
        .TapToPlayCamment = @"TapToPlayCamment",
        .PostponedReminder = @"PostponedReminder",
        .SkippedReminder = @"SkippedReminder",
};

const struct CMOnboardingEvent CMOnboardingEvent = {
        .Started = @"Started",
        .CammentRecorded = @"CammentRecorded",
        .CammentBlockSwipedLeft = @"CammentBlockSwipedLeft",
        .CammentBlockSwipedRight = @"CammentBlockSwipedRight",
        .GroupInfoSidebarOpened = @"GroupInfoSidebarOpened",
        .CammentDeleted = @"CammentDeleted",
        .CammentPlayed = @"CammentPlayed",
        .OnboardingPostponed = @"OnboardingPostponed",
        .OnboardingSkipped = @"OnboardingSkipped",
};