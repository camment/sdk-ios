//
//  CMAppDelegate.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 08/07/2018.
//  Copyright (c) 2018 Alexander Fedosov. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CammentSDK/CammentSDK.h>
#import <CammentAds/CMACammentAds.h>
#import <CammentSDK/CMFacebookIdentityProvider.h>
#import "CMAppDelegate.h"

@interface CMAppDelegate() <CMCammentSDKDelegate>

// Make sure you keep the strong reference to CMFacebookIdentityProvider
@property (nonatomic, strong) CMFacebookIdentityProvider *facebookIdentityProvider;

@end

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    // Configure Camment SDK
    NSString *apiKey = @"YOUR_API_KEY";
    
    self.facebookIdentityProvider = [CMFacebookIdentityProvider new];
    
    [[CammentSDK instance] configureWithApiKey:apiKey
                              identityProvider:self.facebookIdentityProvider];
    [[CMACammentAds sharedInstance] configureWithApiKey:apiKey];
    
    [[CammentSDK instance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    [[CammentSDK instance] application:application openURL:url options:options];
    return handled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [[CammentSDK instance] applicationDidBecomeActive:application];
}

#pragma mark Camment SDK delegate for your app router

- (void)didJoinToShow:(CMShowMetadata * _Nonnull)metadata {
    // User joined the show by deeplink, open your video player view
}

@end
