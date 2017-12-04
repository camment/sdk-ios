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
#import "CMAdsDemoBot.h"

@implementation CMTontonPresentationBuilder


- (NSString *)presentationName {
    return @"Tonton ads demo";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];

    NSArray *subscribeInstructions = @[

    ];

    CMPositionPresentationInstruction *showSubscribeFormInstruction = [[CMPositionPresentationInstruction alloc] initWithPosition:0 action:
            [[CMDisplayViewControllerPresentationAction alloc] initWithPresentationController:[CMTontonGilletteRedeemViewController new]
                                                                                      actions:@{}]
    ];

    NSString *filepath = [[NSBundle cammentSDKBundle] pathForResource:@"Gillette" ofType:@"mov"];
    CMBotAction *action = [CMBotAction new];
    action.botUuid = kCMAdsDemoBotUUID;
    action.action = kCMAdsDemoBotPlayVideoAction;
    action.params = @{
            kCMAdsDemoBotVideoURLParam : [[NSURL alloc] initFileURLWithPath:filepath].absoluteString,
            kCMAdsDemoBotURLParam : @"http://camment.tv",
            kCMAdsDemoBotVideoOnClickPresentationInstructionParam: showSubscribeFormInstruction,
    };

    CMCammentsBlockItem *betBlockItem = [utility blockItemBotAction:@"gl_ads" action:action];
    return @[
            [[CMPositionPresentationInstruction alloc] initWithPosition:1
                                                                 action:[[CMDisplayCammentPresentationAction alloc]
                                                                         initWithItem:betBlockItem] delay:1]

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
