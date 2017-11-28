//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CammentSDK.h"
#import "CMSDKService.h"

@interface CammentSDK()

@property(nonatomic, strong) CMSDKService *sdkService;

@end

@implementation CammentSDK

+ (CammentSDK *)instance {
    static CammentSDK *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sdkService = [[CMSDKService alloc] init];
    }

    return self;
}

- (id <CMCammentSDKDelegate>)sdkDelegate {
    return _sdkService.sdkDelegate;
}

- (void)setSdkDelegate:(id <CMCammentSDKDelegate>)sdkDelegate {
    [_sdkService setSdkDelegate:sdkDelegate];
}

- (id <CMCammentSDKUIDelegate>)sdkUIDelegate {
    return _sdkService.sdkUIDelegate;
}

- (void)setSdkUIDelegate:(id <CMCammentSDKUIDelegate>)sdkUIDelegate {
    [_sdkService setSdkUIDelegate:sdkUIDelegate];
}

- (void)configureWithApiKey:(NSString *_Nonnull)apiKey
           identityProvider:(id <CMIdentityProvider> _Nonnull)identityProvider {
    [_sdkService configureWithApiKey:apiKey
                    identityProvider:identityProvider];
    [_sdkService wakeUpUserSession];
}

- (void)refreshUserIdentity:(BOOL)forceSignIn {
    [_sdkService refreshUserIdentity:forceSignIn];
}

- (void)leaveCurrentChatGroup {
    [_sdkService leaveCurrentChatGroup];
    DDLogDeveloperInfo(@"User left a discussion");
}


- (void)logOut {
    [_sdkService logOut];
}

- (void)applicationDidBecomeActive:(UIApplication *_Nonnull)application {
    [_sdkService applicationDidBecomeActive:application];
}

- (BOOL)application:(UIApplication *_Nonnull)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions {
    return [_sdkService application:application
      didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *_Nonnull)application openURL:(NSURL *_Nonnull)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *_Nullable)options {
    return [_sdkService application:application
                            openURL:url
                            options:options];
}

- (BOOL)openURL:(NSURL *_Nonnull)url sourceApplication:(NSString *_Nullable)application annotation:(id _Nullable)annotation {
    return [_sdkService openURL:url
              sourceApplication:application
                     annotation:annotation];
}

@end
