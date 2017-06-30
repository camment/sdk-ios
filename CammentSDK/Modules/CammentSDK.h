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
#import <CammentSDK/CMCammentAnonymousIdentity.h>
#import <CammentSDK/CMCammentFacebookIdentity.h>
#import <CammentSDK/CMShowsListModule.h>
#import <CammentSDK/CMPublicModuleInterface.h>

@interface CammentSDK: NSObject

+ (CammentSDK * _Nonnull)instance;

- (void)configureWithApiKey:(NSString * _Nonnull)apiKey;

- (void)connectUserWithIdentity:(CMCammentIdentity * _Nonnull)identity
                        success:(void (^ _Nullable)())successBlock
                          error:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;

- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;

- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;

- (BOOL)application:(UIApplication * _Nonnull)application
            openURL:(NSURL * _Nonnull)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nullable)options;
@end
