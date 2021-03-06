//
// Created by Alexander Fedosov on 04.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GVUserDefaults/GVUserDefaults.h>

@interface GVUserDefaults (CammentSDKConfig)

@property (nonatomic) BOOL isOnboardingFinished;
@property (nonatomic) BOOL isOnboardingSkipped;
@property (nonatomic) BOOL isFirstSDKLaunch;
@property (nonatomic) BOOL isInstallationDeeplinkChecked;
@property (nonatomic) NSString *broadcasterPasscode;

@end
