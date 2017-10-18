//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//
#import <Foundation/Foundation.h>

// In this header, you should import all the public headers of your framework using statements like #import <CammentSDK/PublicHeader.h>

#import <CammentSDK/CMCammentIdentity.h>
#import <CammentSDK/CMCammentAnonymousIdentity.h>
#import <CammentSDK/CMCammentFacebookIdentity.h>
#import <CammentSDK/CMShowMetadata.h>
#import <CammentSDK/CMCammentOverlayController.h>

@class CMConnectionReachability;


@protocol CMCammentSDKDelegate <NSObject>

@optional
// Calls when user joined to show.
// Deprecated: use didJoinToShow: instead
- (void)didAcceptInvitationToShow:(CMShowMetadata * _Nonnull)metadata __deprecated;

// Calls when user joined to show
- (void)didJoinToShow:(CMShowMetadata * _Nonnull)metadata;
// Calls when user opened invitation to show
- (void)didOpenInvitationToShow:(CMShowMetadata * _Nonnull)metadata;

// Calls when user accept someone's joining request
- (void)didAcceptJoiningRequest:(CMShowMetadata * _Nonnull)metadata;
@end

@protocol CMCammentSDKUIDelegate <NSObject>

// SDK use the method to display important alerts (invitations, joining requests etc)
- (void)cammentSDKWantsPresentViewController:(UIViewController * _Nonnull)viewController;

@end

@interface CammentSDK: NSObject

@property (nonatomic, weak) id<CMCammentSDKDelegate> _Nullable sdkDelegate;
@property (nonatomic, weak) id<CMCammentSDKUIDelegate> _Nullable sdkUIDelegate;

+ (CammentSDK * _Nonnull)instance;

- (void)configureWithApiKey:(NSString * _Nonnull)apiKey;

- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;

- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;

- (BOOL)application:(UIApplication * _Nonnull)application
            openURL:(NSURL * _Nonnull)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nullable)options;

- (void)renewUserIdentitySuccess:(void (^ _Nullable)())successBlock error:(void (^ _Nullable)(NSError *error))errorBlock;

- (void)logout;
@end
