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
                                                                                  message:@"You will get amazing camments in just a few seconds"
                                                                                  actions:@{
                                                                                          @"Ok": @[]
                                                                                  }
                    ]],
            [[CMPositionPresentationInstruction alloc] initWithPosition:1
                                                                 action:[[CMDisplayCammentPresentationAction alloc] initWithItem:[utility blockItemCammentWithLocalVideo:@"netflix-1"]]
                                                                  delay:2],
            [[CMPositionPresentationInstruction alloc] initWithPosition:0
                                                                 action:[[CMDisplayCammentPresentationAction alloc] initWithItem:[utility blockItemCammentWithLocalVideo:@"netflix-2"]]
                                                                  delay:4],
            [[CMPositionPresentationInstruction alloc] initWithPosition:0
                                                                 action:[[CMDisplayCammentPresentationAction alloc] initWithItem:[utility blockItemCammentWithLocalVideo:@"netflix-3"]]
                                                                  delay:6],
    ];

    CMPositionPresentationInstruction *showSubscribeFormInstruction = [[CMPositionPresentationInstruction alloc] initWithPosition:0 action:
            [[CMDisplayViewControllerPresentationAction alloc] initWithPresentationController:[CMBetViewController new]
                                                                                      actions:@{
                                                                                              @"subscribe": subscribeInstructions
                                                                                      }]
    ];
    return @[
            [[CMPositionPresentationInstruction alloc] initWithPosition:1 action:
                    [[CMDisplayAlertViewControllerPresentationAction alloc] initWithTitle:@"Subscribe to our newsletter"
                                                                                  message:@"And you will get camments from Ben's wedding"
                                                                                  actions:@{
                                                                                          @"Subscribe": showSubscribeFormInstruction,
                                                                                          @"Maybe later": @[]
                                                                                  }
                    ]]
    ];
}

- (void)configureTweaks:(FBTweakCategory *)category {
    FBTweakCollection *settingCollection = [category tweakCollectionWithName:tweakSettingsBettingDemoCollectionName];
    if (!settingCollection) {
        settingCollection = [[FBTweakCollection alloc] initWithName:tweakSettingsBettingDemoCollectionName];
        [category addTweakCollection:settingCollection];
    }
}

@end