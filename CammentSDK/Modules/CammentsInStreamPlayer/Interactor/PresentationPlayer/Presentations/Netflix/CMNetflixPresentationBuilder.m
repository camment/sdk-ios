//
// Created by Alexander Fedosov on 02.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMNetflixPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMPositionPresentationInstruction.h"
#import "CMTimestampPresentationInstruction.h"
#import <FBTweak.h>
#import <FBTweakStore.h>
#import <FBTweakCollection.h>

NSString * const tweakSettingsNetflixCollectionName = @"Netflix settings";
NSString * const tweakSettingsNetflixCammentDelayTemplate = @"#%d camment time";
const NSInteger cammentsCount = 3;

@implementation CMNetflixPresentationBuilder {
}

- (NSString *)presentationName {
    return @"Netflix";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];
    FBTweakCollection *collection = [[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"]
            tweakCollectionWithName:tweakSettingsNetflixCollectionName];


    NSMutableArray *instructions = [NSMutableArray new];
    for (int i = 1; i <= cammentsCount; ++i) {
        NSString *tweakName = [NSString stringWithFormat:tweakSettingsNetflixCammentDelayTemplate, i];
        NSString *cammentName = [NSString stringWithFormat:@"netflix-%d", i];
        FBTweak *cammentDelayTweak = [collection tweakWithIdentifier:tweakName];
        NSTimeInterval timeInterval = [cammentDelayTweak.currentValue ?: cammentDelayTweak.defaultValue floatValue];
        [instructions addObject:[[CMTimestampPresentationInstruction alloc]
                initWithTimestamp:timeInterval
                             item:[utility blockItemCammentWithLocalVideo:cammentName]]];
    }
    return instructions;
}

- (void)configureTweaks:(FBTweakCategory *)category {
    FBTweakCollection *netflixSettingCollection = [category tweakCollectionWithName:tweakSettingsNetflixCollectionName];
    if (!netflixSettingCollection) {
        netflixSettingCollection = [[FBTweakCollection alloc] initWithName:tweakSettingsNetflixCollectionName];
        [category addTweakCollection: netflixSettingCollection];
    }

    NSArray *titles = @[@"Frans camment #1", @"Aleksi's camment", @"Frans camment #2"];
    for (int i = 1; i <= cammentsCount; ++i) {
        NSString *tweakName = [NSString stringWithFormat:tweakSettingsNetflixCammentDelayTemplate, i];
        FBTweak *cammentDelayTweak = [netflixSettingCollection tweakWithIdentifier:tweakName];
        if (!cammentDelayTweak) {
            cammentDelayTweak = [[FBTweak alloc] initWithIdentifier:tweakName];
            cammentDelayTweak.defaultValue = @(3.0f * i);
            cammentDelayTweak.minimumValue = @.0f;
            cammentDelayTweak.maximumValue = @3600.0f;
            cammentDelayTweak.stepValue = @1;
            cammentDelayTweak.name = titles[(NSUInteger) (i - 1)];
            [netflixSettingCollection addTweak:cammentDelayTweak];
        }
    }
}


@end
