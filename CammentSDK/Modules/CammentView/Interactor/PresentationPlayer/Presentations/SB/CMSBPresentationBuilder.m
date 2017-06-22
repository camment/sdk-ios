//
// Created by Alexander Fedosov on 22.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMSBPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "FBTweakStore.h"
#import "FBTweak.h"
#import "FBTweakCollection.h"
#import "CMTimestampPresentationInstruction.h"
#import "CMPositionPresentationInstruction.h"

NSString * const tweakSettingsSBCollectionName = @"Superball settings";
NSString * const tweakSettingSBAdsDelayName = @"Ads delay";

@implementation CMSBPresentationBuilder

- (NSString *)presentationName {
    return @"Superball";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];
    NSNumber *adsDelay = [[[[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"]
            tweakCollectionWithName:tweakSettingsSBCollectionName]
            tweakWithIdentifier:tweakSettingSBAdsDelayName] currentValue] ?: @0;
    NSString *uberEatsAppUrl = @"https://itunes.apple.com/us/app/uber/id1058959277?mt=8";
    return @[
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:3 item:[utility blockItemCammentWithLocalVideo:@"petteri"] delay: adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:4 item:[utility blockItemCammentWithLocalVideo:@"teemu"] delay: adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:5 item:[utility blockItemAdsWithLocalGif:@"ubereats" url:@""] delay: adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:7 item:[utility blockItemAdsWithLocalGif:@"shakeshack" url:uberEatsAppUrl] delay: adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:9 item:[utility blockItemAdsWithLocalGif:@"kokoro" url:uberEatsAppUrl] delay: adsDelay.floatValue],
    ];
}

- (void)configureTweaks:(FBTweakCategory *)category {
    FBTweakCollection *supeballSettingCollection = [category tweakCollectionWithName:tweakSettingsSBCollectionName];
    if (!supeballSettingCollection) {
        supeballSettingCollection = [[FBTweakCollection alloc] initWithName:tweakSettingsSBCollectionName];
        [category addTweakCollection: supeballSettingCollection];
    }

    FBTweak *delayTweak = [supeballSettingCollection tweakWithIdentifier:tweakSettingSBAdsDelayName];
    if (!delayTweak) {
        delayTweak = [[FBTweak alloc] initWithIdentifier:tweakSettingSBAdsDelayName];
        delayTweak.defaultValue = @1.0f;
        delayTweak.currentValue = @1.0f;
        delayTweak.stepValue = @1;
        delayTweak.minimumValue = @.0f;
        delayTweak.maximumValue = @10.0f;
        delayTweak.name = @"Delay between camments";
        [supeballSettingCollection addTweak:delayTweak];
    }
}

@end
