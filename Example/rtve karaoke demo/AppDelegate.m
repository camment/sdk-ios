//
//  AppDelegate.m
//  rtve karaoke demo
//
//  Created by Alexander Fedosov on 12.04.2018.
//  Copyright © 2018 Alexander Fedosov. All rights reserved.
//

#import "AppDelegate.h"
#import <CammentSDK/CammentSDK.h>
#import <CammentSDK/CMFacebookIdentityProvider.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@property (nonatomic, strong) CMFacebookIdentityProvider *facebookIdentityProvider;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    self.facebookIdentityProvider = [CMFacebookIdentityProvider new];
    [[CammentSDK instance] configureWithApiKey:@""
                              identityProvider:self.facebookIdentityProvider];
    
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

// here we implement method to support ios 8.1
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(id)annotation
{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    [[CammentSDK instance] openURL:url sourceApplication:sourceApplication annotation:annotation];
    return handled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [[CammentSDK instance] applicationDidBecomeActive:application];
}

@end
