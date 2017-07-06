//
// Created by Alexander Fedosov on 04.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "GVUserDefaults+CammentSDKConfig.h"


@implementation GVUserDefaults (CammentSDKConfig)

@dynamic isOnboardingFinished;

- (NSDictionary *)setupDefaults {
    return @{
            @"isOnboardingFinished": @NO
    };
}

@end