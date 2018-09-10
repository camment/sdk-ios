//
// Created by Alexander Fedosov on 09.01.2018.
//

#import "CMImageAdPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMBotAction.h"
#import "CMAdsDemoBot.h"
#import "CMBotCamment.h"
#import "CMCammentsBlockItem.h"
#import "CMPositionPresentationInstruction.h"
#import "CMPresentationPlayerBot.h"


@implementation CMImageAdPresentationBuilder {

}
- (NSString *)presentationName {
    return @"Image ad demo";
}

- (NSArray *)instructions {
    CMBotAction *action = [[CMBotAction alloc] init];
    action.botUuid = kCMAdsDemoBotUUID;
    action.action = kCMAdsDemoBotPlayVideoAction;
    action.params = @{
            kCMAdsDemoBotURLParam : @"http://braun.fi",
            kCMAdsDemoBotPlaceholderURLParam : @"https://s3.eu-central-1.amazonaws.com/camment-dev-ads/0714fe76-a6f6-47d4-afd8-2c41fc8c4a67.jpg"
    };
    CMBotCamment *botCamment = [[CMBotCamment alloc] initWithURL:@"https://s3.eu-central-1.amazonaws.com/camment-dev-ads/0714fe76-a6f6-47d4-afd8-2c41fc8c4a67.jpg"
                                                       botAction:action];

    CMCammentsBlockItem *gilletteAdsBlockItem = [CMCammentsBlockItem botCammentWithBotCamment:botCamment];

    return @[
            [[CMPositionPresentationInstruction alloc] initWithPosition:17
                                                                 action:[[CMDisplayCammentPresentationAction alloc]
                                                                         initWithItem:gilletteAdsBlockItem] delay:3],
    ];
}

- (void)configureTweaks:(FBTweakCategory *)category {

}

- (NSArray<id <CMBot>> *)bots {
    return @[
            [CMPresentationPlayerBot new],
            [CMAdsDemoBot new]
    ];
}

@end