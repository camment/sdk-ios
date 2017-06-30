//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CammentSDK.h"
#import "CMStore.h"
#import "CMAnalytics.h"
#import "CMCognitoAuthService.h"
#import "CMCognitoFacebookAuthProvider.h"
#import "CMCamment.h"
#import "CMServerListenerCredentials.h"
#import "CMServerListener.h"
#import "CMCammentFacebookIdentity.h"
#import "CMCammentAnonymousIdentity.h"
#import "CMPresentationBuilder.h"
#import "CMWoltPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "ServerMessage.h"
#import "UsersGroupBuilder.h"
#import "UIViewController+topVisibleViewController.h"
#import "CMDevcammentClient.h"
#import "CMAppConfig.h"
#import "CMInvitationViewController.h"

#import <FBTweak.h>
#import <FBTweakStore.h>
#import <FBTweakCollection.h>
#import <FBTweakCategory.h>

@interface CammentSDK ()
@property(nonatomic, strong) CMCognitoAuthService *authService;
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

        [DDLog addLogger:[DDTTYLogger sharedInstance]];

        DDLogInfo(@"Camment SDK has started");
        [self setupTweaks];
    }

    return self;
}

- (void)setupTweaks {
    FBTweakStore *store = [FBTweakStore sharedInstance];

    FBTweakCategory *presentationCategory = [store tweakCategoryWithName:@"Predefined stuff"];
    if (!presentationCategory) {
        presentationCategory = [[FBTweakCategory alloc] initWithName:@"Predefined stuff"];
        [store addTweakCategory:presentationCategory];
    }

    FBTweakCollection *presentationsCollection = [presentationCategory tweakCollectionWithName:@"Demo"];
    if (!presentationsCollection) {
        presentationsCollection = [[FBTweakCollection alloc] initWithName:@"Demo"];
        [presentationCategory addTweakCollection:presentationsCollection];
    }

    NSArray<id <CMPresentationBuilder>> *presentations = [CMPresentationUtility activePresentations];

    FBTweak *showTweak = [presentationsCollection tweakWithIdentifier:@"Scenario"];
    if (!showTweak) {
        showTweak = [[FBTweak alloc] initWithIdentifier:@"Scenario"];
        showTweak.possibleValues = [@[@"None"] arrayByAddingObjectsFromArray:[presentations.rac_sequence map:^id(id <CMPresentationBuilder> value) {
            return [value presentationName];
        }].array];
        showTweak.defaultValue = @"None";
        showTweak.name = @"Choose demo scenario";
        [presentationsCollection addTweak:showTweak];
    }

    for (id <CMPresentationBuilder> presentation in presentations) {
        [presentation configureTweaks:presentationCategory];
    }

    FBTweakCollection *webSettingCollection = [presentationCategory tweakCollectionWithName:@"Web settings"];
    if (!webSettingCollection) {
        webSettingCollection = [[FBTweakCollection alloc] initWithName:@"Web settings"];
        [presentationCategory addTweakCollection:webSettingCollection];
    }

    NSString *tweakName = @"Web page url";
    FBTweak *cammentDelayTweak = [webSettingCollection tweakWithIdentifier:tweakName];
    if (!cammentDelayTweak) {
        cammentDelayTweak = [[FBTweak alloc] initWithIdentifier:tweakName];
        cammentDelayTweak.defaultValue = @"http://aftonbladet.se";
        cammentDelayTweak.currentValue = @"http://aftonbladet.se";
        cammentDelayTweak.name = tweakName;
        [webSettingCollection addTweak:cammentDelayTweak];
    }

    FBTweakCategory *settingsCategory = [store tweakCategoryWithName:@"Settings"];
    if (!settingsCategory) {
        settingsCategory = [[FBTweakCategory alloc] initWithName:@"Settings"];
        [store addTweakCategory:settingsCategory];
    }

    FBTweakCollection *videoSettingsCollection = [presentationCategory tweakCollectionWithName:@"Video player settings"];
    if (!videoSettingsCollection) {
        videoSettingsCollection = [[FBTweakCollection alloc] initWithName:@"Video player settings"];
        [settingsCategory addTweakCollection:videoSettingsCollection];
    }

    FBTweak *volumeTweak = [presentationsCollection tweakWithIdentifier:@"Volume"];
    if (!volumeTweak) {
        volumeTweak = [[FBTweak alloc] initWithIdentifier:@"Volume"];
        volumeTweak.minimumValue = @.0f;
        volumeTweak.stepValue = @10.0f;
        volumeTweak.maximumValue = @100.0f;
        volumeTweak.defaultValue = @30.0f;
        volumeTweak.name = @"Volume (%)";
        [videoSettingsCollection addTweak:volumeTweak];
    }

    DDLogInfo(@"Tweaks hav been configured");
}

- (void)configureWithApiKey:(NSString *)apiKey {
    [self configure];
    [self launch];
    CMCammentIdentity *identity = [CMCammentAnonymousIdentity new];

    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
    if ([CMStore instance].isFBConnected) {
        identity = [CMCammentFacebookIdentity identityWithFBSDKAccessToken:token];
    }

    [self connectUserWithIdentity:identity
                          success:nil
                            error:nil];
}

- (void)connectUserWithIdentity:(CMCammentIdentity *)identity
                        success:(void (^ _Nullable)())successBlock
                          error:(void (^ _Nullable)(NSError *error))errorBlock {

    [self.authService refreshIdentity];
    if ([identity isKindOfClass:[CMCammentFacebookIdentity class]]) {
        [self.authService configureWithProvider:[CMCognitoFacebookAuthProvider new]];
        CMCammentFacebookIdentity *cammentFacebookIdentity = (CMCammentFacebookIdentity *) identity;
        [FBSDKAccessToken setCurrentAccessToken:cammentFacebookIdentity.fbsdkAccessToken];
        [self signInUserWithSuccess:successBlock error:errorBlock];
    } else if ([identity isKindOfClass:[CMCammentAnonymousIdentity class]]) {
        [self signInUserWithSuccess:successBlock error:errorBlock];
    } else {
        DDLogError(@"Trying to connect unknown idenity %@", [identity class]);
        if (errorBlock) {
            errorBlock([NSError
                    errorWithDomain:@"tv.camment.ios"
                               code:0
                           userInfo:@{}]);
        }
    }
}

- (void)signInUserWithSuccess:(void (^ _Nullable)())successBlock
                        error:(void (^ _Nullable)(NSError *error))errorBlock {
    [[self.authService signIn]
            subscribeNext:^(NSString *cognitoUserId) {
                [[CMStore instance] setCognitoUserId:cognitoUserId];
            }
                    error:^(NSError *error) {
                        [[CMStore instance] setIsSignedIn:NO];
                        DDLogError(@"%@", error);

                        if (errorBlock) {
                            errorBlock(error);
                        }
                    }
                completed:^{
                    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
                    [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
                    [self updateUserInfo];
                    [[CMStore instance] setIsSignedIn:YES];
                    [self configureIoTListener:[CMStore instance].cognitoUserId];
                    if (successBlock) {successBlock();}
                }];
}

- (void)updateUserInfo {

    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    if (!profile) {
        DDLogVerbose(@"FB profile not found");
        return;
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    if (profile.name) {
        userInfo[@"name"] = profile.name;
    }

    NSURL *imageUrl = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(270, 270)];
    if (imageUrl) {
        userInfo[@"picture"] = imageUrl.absoluteString;
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                       options:0
                                                         error:&error];
    if (!jsonData) {return;}

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!jsonString) {return;}

    CMUserinfoInRequest *userinfoInRequest = [CMUserinfoInRequest new];
    userinfoInRequest.userinfojson = jsonString;

    CMDevcammentClient *client = [CMDevcammentClient defaultClient];
    [[client userinfoPost:userinfoInRequest] continueWithBlock:^id(AWSTask<id> *t) {
        if (!t.error) {
            DDLogVerbose(@"User info has been updated with data %@", userInfo);
        }
        return nil;
    }];
}

- (void)launch {
}

- (void)configure {
    [FBSDKSettings setAppID:[CMAppConfig instance].fbAppId];
    [[CMAnalytics instance] configureAWSMobileAnalytics];
    self.authService = [[CMCognitoAuthService alloc] init];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:FBSDKProfileDidChangeNotification object:nil];
}

- (void)configureIoTListener:(NSString *)userId {
    CMServerListenerCredentials *credentials =
            [[CMServerListenerCredentials alloc] initWithClientId:userId
                                                          keyFile:@"awsiot-identity"
                                                       passPhrase:@"8uT$BwY+x=DF,M"
                                                    certificateId:nil];

    CMServerListener *listener = [CMServerListener instanceWithCredentials:credentials];
    [listener connect];
    [listener.messageSubject subscribeNext:^(ServerMessage *message) {
        [message matchInvitation:^(Invitation *invitation) {
            if (![invitation.userGroupUuid isEqualToString:[CMStore instance].cognitoUserId]) {
                [self presentChatInvitation:invitation];
            }
        }                camment:^(Camment *camment) {

        }];
    }];
}

- (void)presentChatInvitation:(Invitation *)invitation {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"User invited you to a private chat"
                                                                             message:@"Would you like to join the conversation?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Join" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UsersGroup *usersGroup = [[[UsersGroupBuilder new] withUuid:invitation.userGroupUuid] build];
        [[CMStore instance] setActiveGroup:usersGroup];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];

    UIViewController *presentedViewController = [rootViewController topVisibleViewController];


    dispatch_async(dispatch_get_main_queue(), ^{
        if ([presentedViewController isKindOfClass:[CMInvitationViewController class]] && presentedViewController.beingPresented) {
            [presentedViewController dismissViewControllerAnimated:YES
                                                        completion:^{
                                                            [presentedViewController presentViewController:alertController
                                                                                                  animated:YES
                                                                                                completion:nil];
                                                        }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [presentedViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
            });
        }
    });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DDLogInfo(@"applicationDidBecomeActive hook has been installed");
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDLogInfo(@"didFinishLaunchingWithOptions hook has been installed");
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    DDLogInfo(@"openURL hook has been installed");
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
    ];
}

@end
