//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CammentSDK.h"
#import "CMSDKService.h"
#import "CMAppConfig.h"

NSString *const CMNewTimestampAvailableVideoPlayerNotification = @"CMNewTimestampAvailableVideoPlayerNotification";
NSString *const CMNewTimestampKey = @"CMNewTimestampKey";
NSString *const CMShowUUIDKey = @"CMNewShowUUIDKey";
NSString *const CMVideoIsPlayingKey = @"CMVideoIsPlayingKey";

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
    CMAppConfig *appConfig = [[CMAppConfig alloc] init:@"production"];
    [self configureWithApiKey:apiKey
             identityProvider:identityProvider
                    appConfig:appConfig];
}

- (void)configureWithApiKey:(NSString *_Nonnull)apiKey
           identityProvider:(id <CMIdentityProvider> _Nonnull)identityProvider
                  appConfig:(CMAppConfig *)appConfig {
    [_sdkService configureWithApiKey:apiKey identityProvider:identityProvider appConfig:appConfig];
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

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *_Nonnull)metadata timestamp:(NSTimeInterval)timestamp {
    [_sdkService updateVideoStreamStateIsPlaying:isPlaying show:metadata timestamp:timestamp];
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

@end
