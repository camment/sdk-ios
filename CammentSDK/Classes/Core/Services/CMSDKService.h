//
//  CMSDKService.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 22.11.2017.
//

#import <Foundation/Foundation.h>

@protocol CMCammentSDKDelegate;
@protocol CMCammentSDKUIDelegate;
@protocol CMIdentityProvider;
@class CMAWSServicesFactory;
@class CMConnectionReachability;
@class CMUserSessionController;
@protocol CMSDKNotificationPresenterPresenterInput;
@class CMServerListener;
@class CMServerMessageController;

@interface CMSDKService : NSObject

@property(nonatomic, strong) CMAWSServicesFactory *awsServicesFactory;
@property(nonatomic) BOOL connectionAvailable;

@property(nonatomic) NSOperationQueue *onSignedInOperationsQueue;
@property(nonatomic) NSOperationQueue *onSDKHasBeenConfiguredQueue;

@property(nonatomic, strong) CMConnectionReachability *connectionReachibility;

@property(nonatomic, strong) DDFileLogger *fileLogger;

@property(nonatomic, strong) CMUserSessionController *userSessionController;
@property(nonatomic, strong) id <CMSDKNotificationPresenterPresenterInput> notificationPresenter;
@property(nonatomic, strong) CMServerListener *serverListener;
@property(nonatomic, strong) CMServerMessageController *serverMessageController;

@property (nonatomic, weak) id<CMCammentSDKDelegate> _Nullable sdkDelegate;
@property (nonatomic, weak) id<CMCammentSDKUIDelegate> _Nullable sdkUIDelegate;

- (void)configureWithApiKey:(NSString *_Nonnull)apiKey identityProvider:(id <CMIdentityProvider> _Nonnull)identityProvider;

- (void)wakeUpUserSession;

- (void)refreshUserIdentity:(BOOL)forceSignIn;
- (void)logOut;

- (void)applicationDidBecomeActive:(UIApplication * _Nonnull)application;

- (BOOL)application:(UIApplication * _Nonnull)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)launchOptions;

- (BOOL)application:(UIApplication * _Nonnull)application
            openURL:(NSURL * _Nonnull)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> * _Nullable)options;

- (BOOL)openURL:(NSURL * _Nonnull)url sourceApplication:(NSString * _Nullable)application
     annotation:(id _Nullable)annotation NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;


@end
