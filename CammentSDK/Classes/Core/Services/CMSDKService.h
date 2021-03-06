//
//  CMSDKService.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 22.11.2017.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@protocol CMCammentSDKDelegate;
@protocol CMCammentSDKUIDelegate;
@protocol CMIdentityProvider;
@class CMAWSServicesFactory;
@class CMConnectionReachability;
@class CMUserSessionController;
@protocol CMSDKNotificationPresenterPresenterInput;
@class CMServerListener;
@class CMServerMessageController;
@class CMInvitation;
@class CMShowMetadata;
@class CMAppConfig;

@interface CMSDKService : NSObject

@property(nonatomic, strong) CMAWSServicesFactory  * _Nullable awsServicesFactory;

@property(nonatomic) NSOperationQueue * _Nullable onSignedInOperationsQueue;
@property(nonatomic) NSOperationQueue * _Nullable onSDKHasBeenConfiguredQueue;

@property(nonatomic, strong) CMConnectionReachability * _Nullable connectionReachibility;

@property(nonatomic, strong) DDFileLogger * _Nullable fileLogger;

@property(nonatomic, strong) CMUserSessionController * _Nullable userSessionController;
@property(nonatomic, strong) id <CMSDKNotificationPresenterPresenterInput> _Nullable notificationPresenter;
@property(nonatomic, strong) CMServerListener * _Nullable serverListener;
@property(nonatomic, strong) CMServerMessageController * _Nullable serverMessageController;

@property (nonatomic, weak) id<CMCammentSDKDelegate> _Nullable sdkDelegate;
@property (nonatomic, weak) id<CMCammentSDKUIDelegate> _Nullable sdkUIDelegate;

- (void)configureWithApiKey:(NSString *_Nonnull)apiKey identityProvider:(id <CMIdentityProvider> _Nonnull)identityProvider appConfig:(CMAppConfig *)appConfig;

- (void)wakeUpUserSession;

- (void)refreshUserIdentity:(BOOL)forceSignIn;
- (void)logOut;

- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;

- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;

- (BOOL)application:(UIApplication * _Nonnull)application
            openURL:(NSURL * _Nonnull)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nullable)options;

- (void)verifyInvitation:(CMInvitation *)invitation;

- (void)leaveCurrentChatGroup;

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *)show timestamp:(NSTimeInterval)timestamp;

@end
