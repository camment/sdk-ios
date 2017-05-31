//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMWoltPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMPositionPresentationInstruction.h"
#import <FBTweak.h>
#import <FBTweakStore.h>
#import <FBTweakCategory.h>
#import <FBTweakCollection.h>

@implementation CMWoltPresentationBuilder

- (NSArray *)instructions {

    CMPresentationUtility *utility = [CMPresentationUtility new];
    NSNumber *adsDelay = [[[[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"] tweakCollectionWithName:@"Presentations"] tweakWithIdentifier:@"Ads delay"] currentValue] ?: @0;
    NSString *woltUrl = @"https://itunes.apple.com/fi/app/wolt/id943905271?mt=8";
    return @[
            [[CMPositionPresentationInstruction alloc]
             initWithPosition:3 item:[utility blockItemAdsWithLocalGif:@"wolt" url:@""] delay: adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:5 item:[utility blockItemAdsWithLocalGif:@"burger" url:woltUrl] delay: adsDelay.floatValue],
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:7 item:[utility blockItemAdsWithLocalGif:@"sushi" url:woltUrl] delay: adsDelay.floatValue],
    ];
}


@end
