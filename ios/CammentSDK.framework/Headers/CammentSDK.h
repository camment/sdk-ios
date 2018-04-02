//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CammentSDK/CMShowMetadata.h>
#import <CammentSDK/CMCammentOverlayLayoutConfig.h>
#import <CammentSDK/CMCammentOverlayController.h>
#import <CammentSDK/CMIdentityProvider.h>

@protocol CMCammentSDKDelegate <NSObject>

/**
 * Calls when user joined to show
 * @param metadata Class provides additional information related to your show
 */
- (void)didJoinToShow:(CMShowMetadata * _Nonnull)metadata;

@optional

/**
 * Calls when user opens invitation to show
 * Use this delegate's method to open the show in your player
 * @param metadata Class provides additional information related to your show
 */
- (void)didOpenInvitationToShow:(CMShowMetadata * _Nonnull)metadata;

/**
 * Calls when user joined to show.
 * @deprecated: use didJoinToShow: instead
 * @param metadata Class provides additional information related to your show
 */
- (void)didAcceptInvitationToShow:(CMShowMetadata * _Nonnull)metadata __deprecated;

/**
 * Calls when user accept someone's joining request
 * @deprecated: use didJoinToShow: instead
 * @param metadata Class provides additional information related to your show
 */
- (void)didAcceptJoiningRequest:(CMShowMetadata * _Nonnull)metadata __deprecated;
@end

@protocol CMCammentSDKUIDelegate <NSObject>

/**
 * SDK use the method to display important alerts (invitations, joining requests etc)
 * @param viewController UIViewController needed to be presented
 */
- (void)cammentSDKWantsPresentViewController:(UIViewController * _Nonnull)viewController;

@end

@interface CammentSDK: NSObject

@property (nonatomic, weak) id<CMCammentSDKDelegate> _Nullable sdkDelegate;
@property (nonatomic, weak) id<CMCammentSDKUIDelegate> _Nullable sdkUIDelegate;

+ (CammentSDK * _Nonnull)instance;

/**
 * Use this method to provide your API key and identityProvider
 * As identity provider you can use default CMFacebookIdentityProvider
 * @param apiKey The API key provided to client allows to get access to Camment backend
 * @param identityProvider Any class which implements CMIdentityProvider protocol.
 *                          Needs to perform authentication for a Camment user
 */
- (void)configureWithApiKey:(NSString *_Nonnull)apiKey identityProvider:(id <CMIdentityProvider> _Nonnull)identityProvider;

/**
 * Asks CMIdentityProvider to pass user credentials to CammentSDK.
 *
 * Use refreshUserIdentity:NO to update user session with cached credentials
 * Use refreshUserIdentity:YES if you want force user to login to CammentSDK. In most cases you will not use it directly.
 *
 * @param forceSignIn The flag tells to CMIdentityProvider if it should force user to login if there no cached credentials found
 */
- (void)refreshUserIdentity:(BOOL)forceSignIn;

/**
 * Cleans up current chat group
 */
- (void)leaveCurrentChatGroup;

/**
 * Cleans up all user credentials and log user out of CammentSDK
 * Also, runs -logOut method for identityProvider class
 */
- (void)logOut;

/**
 * Proxy methods for appDelegate. Used for additional SDK configuration and handling invitations by deeplink
 */
- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;

- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;

- (BOOL)application:(UIApplication * _Nonnull)application
            openURL:(NSURL * _Nonnull)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nullable)options;

- (BOOL)openURL:(NSURL * _Nonnull)url sourceApplication:(NSString * _Nullable)application
     annotation:(id _Nullable)annotation NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;

@end
