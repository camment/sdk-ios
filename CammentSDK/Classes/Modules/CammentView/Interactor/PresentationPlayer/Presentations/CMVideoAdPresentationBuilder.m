//
// Created by Alexander Fedosov on 27.10.2017.
//

#import "CMVideoAdPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "FBTweakStore.h"
#import "CMPositionPresentationInstruction.h"
#import "CMAdsDemoBot.h"

NSString * const tweakSettingsVideoAdCollectionName = @"Video ad settings";

@implementation CMVideoAdPresentationBuilder

- (NSString *)presentationName {
    return @"Video ad";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];

    NSString *filepath = [[NSBundle cammentSDKBundle] pathForResource:@"ronaldo-ad" ofType:@"mp4"];
    CMBotAction *action = [CMBotAction new];
    action.botUuid = kCMAdsDemoBotUUID;
    action.action = kCMAdsDemoBotPlayVideoAction;
    action.params = @{
            kCMAdsDemoBotVideoURLParam : [[NSURL alloc] initFileURLWithPath:filepath].absoluteString,
            kCMAdsDemoBotURLParam : @"http://zara.com",
    };

    return @[
            [[CMPositionPresentationInstruction alloc]
                    initWithPosition:3
                              action:[utility displayBotActionWithLocalGif:@"ronaldo" action:action]
                               delay:1.0f],
    ];
}

- (void)configureTweaks:(FBTweakCategory *)category {

}

- (NSArray<id <CMBot>> *)bots {
    return @[
            [CMAdsDemoBot new]
    ];
}

@end