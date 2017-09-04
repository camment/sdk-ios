//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMWoltPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMPositionPresentationInstruction.h"
#import "FBTweak.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"

NSString * const tweakSettingsWoltCollectionName = @"Wolt settings";
NSString * const tweakSettingWoltAdsDelayName = @"Ads delay";

@implementation CMWoltPresentationBuilder

- (NSString *)presentationName {
    return @"Wolt";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];
    NSNumber *adsDelay = [[[[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"]
            tweakCollectionWithName:tweakSettingsWoltCollectionName]
            tweakWithIdentifier:tweakSettingWoltAdsDelayName] currentValue] ?: @0;
    NSString *woltUrl = @"https://itunes.apple.com/fi/app/wolt/id943905271?mt=8";
    return @[
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:3 action:[utility displayCammentActionWithLocalGif:@"wolt" url:@""] delay:adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:5 action:[utility displayCammentActionWithLocalGif:@"burger" url:woltUrl] delay:adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:7 action:[utility displayCammentActionWithLocalGif:@"sushi" url:woltUrl] delay:adsDelay.floatValue],
    ];
}

- (void)configureTweaks:(FBTweakCategory *)category {
    FBTweakCollection *woltSettingCollection = [category tweakCollectionWithName:tweakSettingsWoltCollectionName];
    if (!woltSettingCollection) {
        woltSettingCollection = [[FBTweakCollection alloc] initWithName:tweakSettingsWoltCollectionName];
        [category addTweakCollection: woltSettingCollection];
    }

    FBTweak *delayTweak = [woltSettingCollection tweakWithIdentifier:tweakSettingWoltAdsDelayName];
    if (!delayTweak) {
        delayTweak = [[FBTweak alloc] initWithIdentifier:tweakSettingWoltAdsDelayName];
        delayTweak.defaultValue = @1.0f;
        delayTweak.currentValue = @1.0f;
        delayTweak.stepValue = @1;
        delayTweak.minimumValue = @.0f;
        delayTweak.maximumValue = @10.0f;
        delayTweak.name = @"How fast ads appears";
        [woltSettingCollection addTweak:delayTweak];
    }
}


@end
