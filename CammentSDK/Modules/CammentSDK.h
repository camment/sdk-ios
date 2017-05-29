//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for CammentSDK.
FOUNDATION_EXPORT double CammentSDKVersionNumber;

//! Project version string for CammentSDK.
FOUNDATION_EXPORT const unsigned char CammentSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <CammentSDK/PublicHeader.h>

#import <CammentSDK/CMCammentIdentity.h>
#import <CammentSDK/CMCammentFacebookIdentity.h>
#import <CammentSDK/CMShowsListModule.h>
#import <CammentSDK/CMPublicModuleInterface.h>

@interface CammentSDK: NSObject
+ (CammentSDK *)instance;

- (void)configureWithApiKey:(NSString *)apiKey;
- (void)connectUserWithIdentity:(CMCammentIdentity *)identity;
@end
