//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMBettingPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMPositionPresentationInstruction.h"
#import "CMDisplayAlertViewControllerPresentationAction.h"
#import "CMDisplayViewControllerPresentationAction.h"
#import "CMEmailSubscriptionViewController.h"
#import "FBTweakCollection.h"
#import "CMBetViewController.h"
#import "CMPresentationPlayerBot.h"

NSString *const tweakSettingsBettingDemoCollectionName = @"Betting demo settings";

@implementation CMBettingPresentationBuilder {
}

- (NSString *)presentationName {
    return @"Betting demo";
}

- (NSArray *)instructions {
    CMPresentationUtility *utility = [CMPresentationUtility new];

    NSArray *subscribeInstructions = @[
            [[CMPositionPresentationInstruction alloc] initWithPosition:1 action:
                    [[CMDisplayAlertViewControllerPresentationAction alloc] initWithTitle:@"Done!"
                                                                                  message:@"Let's see how lucky you are"
                                                                                  actions:@{
                                                                                          @"Ok": @[]
                                                                                  }
                    ]]
    ];

    CMPositionPresentationInstruction *showSubscribeFormInstruction = [[CMPositionPresentationInstruction alloc] initWithPosition:0 action:
            [[CMDisplayViewControllerPresentationAction alloc] initWithPresentationController:[CMBetViewController new]
                                                                                      actions:@{
                                                                                              @"bet": subscribeInstructions
                                                                                      }]
    ];
    CMBotAction *action = [CMBotAction new];
    action.botUuid = kCMPresentationPlayerBotUUID;
    action.action = kCMPresentationPlayerBotPlayAction;
    action.params = @{
            kCMPresentationPlayerBotRunableParam : showSubscribeFormInstruction
    };

    CMCammentsBlockItem *betBlockItem = [utility blockItemBotAction:@"bet" action:action];
    return @[
            [[CMPositionPresentationInstruction alloc] initWithPosition:1
                                                                 action:[[CMDisplayCammentPresentationAction alloc] initWithItem:betBlockItem]]

    ];
}

- (void)configureTweaks:(FBTweakCategory *)category {
    FBTweakCollection *settingCollection = [category tweakCollectionWithName:tweakSettingsBettingDemoCollectionName];
    if (!settingCollection) {
        settingCollection = [[FBTweakCollection alloc] initWithName:tweakSettingsBettingDemoCollectionName];
        [category addTweakCollection:settingCollection];
    }
}

- (NSArray<id <CMBot>> *)bots {
    return @[
            [CMPresentationPlayerBot new]
    ];
}

@end
