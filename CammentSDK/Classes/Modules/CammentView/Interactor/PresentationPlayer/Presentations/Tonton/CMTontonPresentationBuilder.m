//
//  CMTontonPresentationBuilder.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 04.12.2017.
//

#import "CMTontonPresentationBuilder.h"
#import "CMPresentationBuilder.h"
#import "CMPresentationPlayerBot.h"
#import "CMPresentationUtility.h"
#import "CMPositionPresentationInstruction.h"
#import "CMDisplayViewControllerPresentationAction.h"
#import "CMTontonGilletteRedeemViewController.h"
#import "CMTontonPizzaHutViewController.h"
#import "CMAdsDemoBot.h"

@implementation CMTontonPresentationBuilder


- (NSString *)presentationName {
    return @"Tonton ads demo";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];

    NSArray *subscribeInstructions = @[

    ];

    CMPositionPresentationInstruction *showGilletteRedeemVC = [[CMPositionPresentationInstruction alloc] initWithPosition:0 action:
            [[CMDisplayViewControllerPresentationAction alloc] initWithPresentationController:[CMTontonGilletteRedeemViewController new]
                                                                                      actions:@{}]
    ];

    CMPositionPresentationInstruction *showPizzaHutOrderVC = [[CMPositionPresentationInstruction alloc] initWithPosition:3 action:
            [[CMDisplayViewControllerPresentationAction alloc] initWithPresentationController:[CMTontonPizzaHutViewController new]
                                                                                      actions:@{}]
    ];

    NSString *filepath = [[NSBundle cammentSDKBundle] pathForResource:@"Gillette" ofType:@"mov"];
    CMBotAction *action = [CMBotAction new];
    action.botUuid = kCMAdsDemoBotUUID;
    action.action = kCMAdsDemoBotPlayVideoAction;
    action.params = @{
            kCMAdsDemoBotVideoURLParam : [[NSURL alloc] initFileURLWithPath:filepath].absoluteString,
            kCMAdsDemoBotURLParam : @"http://camment.tv",
            kCMAdsDemoBotVideoOnClickPresentationInstructionParam: showGilletteRedeemVC,
    };


    CMBotAction *showPizzaHutOrderAds = [CMBotAction new];
    showPizzaHutOrderAds.botUuid = kCMPresentationPlayerBotUUID;
    showPizzaHutOrderAds.action = kCMPresentationPlayerBotPlayAction;
    showPizzaHutOrderAds.params = @{
            kCMPresentationPlayerBotRunableParam : showPizzaHutOrderVC
    };

    CMCammentsBlockItem *gilletteAdsBlockItem = [utility blockItemBotAction:@"gl_ads" action:action];
    CMCammentsBlockItem *phAdsBlockItem = [utility blockItemBotAction:@"ph" action:showPizzaHutOrderAds];
    CMCammentsBlockItem *cammentsBlockItem = [utility blockItemCammentWithLocalVideo:@"hiben"];
    return @[
            [[CMPositionPresentationInstruction alloc] initWithPosition:4
                                                                 action:[[CMDisplayCammentPresentationAction alloc]
                                                                         initWithItem:gilletteAdsBlockItem] delay:1],
            [[CMPositionPresentationInstruction alloc] initWithPosition:2
                                                                 action:[[CMDisplayCammentPresentationAction alloc]
                                                                         initWithItem:cammentsBlockItem] delay:1],
            [[CMPositionPresentationInstruction alloc] initWithPosition:6
                                                                 action:[[CMDisplayCammentPresentationAction alloc]
                                                                         initWithItem:phAdsBlockItem] delay:1],
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
