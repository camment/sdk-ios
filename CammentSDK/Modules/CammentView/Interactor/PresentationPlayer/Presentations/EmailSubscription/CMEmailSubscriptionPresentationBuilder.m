//
// Created by Alexander Fedosov on 01.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMEmailSubscriptionPresentationBuilder.h"
#import "FBTweakCollection.h"
#import "CMPresentationUtility.h"
#import "CMDisplayAlertViewControllerPresentationAction.h"
#import "CMPositionPresentationInstruction.h"
#import "CMDisplayViewControllerPresentationAction.h"
#import "CMEmailSubscriptionViewController.h"

NSString *const tweakSettingsEmailsSubscriptionCollectionName = @"Email subscription settings";

@implementation CMEmailSubscriptionPresentationBuilder

- (NSString *)presentationName {
    return @"Email subscription";
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
            [[CMDisplayViewControllerPresentationAction alloc] initWithPresentationController:[CMEmailSubscriptionViewController new]
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
    FBTweakCollection *woltSettingCollection = [category tweakCollectionWithName:tweakSettingsEmailsSubscriptionCollectionName];
    if (!woltSettingCollection) {
        woltSettingCollection = [[FBTweakCollection alloc] initWithName:tweakSettingsEmailsSubscriptionCollectionName];
        [category addTweakCollection:woltSettingCollection];
    }
}

@end
