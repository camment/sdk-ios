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
#import "CMAPICamment.h"
#import "CMServerListenerCredentials.h"
#import "CMServerListener.h"
#import "CMCammentFacebookIdentity.h"
#import "CMCammentAnonymousIdentity.h"
#import "CMPresentationBuilder.h"
#import "CMWoltPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMServerMessage.h"
#import "CMUsersGroupBuilder.h"
#import "UIViewController+topVisibleViewController.h"
#import "CMAPIDevcammentClient.h"
#import "CMAppConfig.h"
#import "CMInvitationViewController.h"
#import "CMUserBuilder.h"
#import "CMInvitationBuilder.h"
#import "CMConnectionReachability.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "AWSTask.h"

#import <FBTweak.h>
#import <FBTweakStore.h>
#import <FBTweakCollection.h>
#import <FBTweakCategory.h>

@interface CammentSDK ()

@property(nonatomic, strong) CMCognitoAuthService *authService;
@property(nonatomic) BOOL connectionAvailable;

@property(nonatomic, strong) CMConnectionReachability *connectionReachibility;
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

#ifdef DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
#else
        [DDLog addLogger:[[DDFileLogger alloc] init]];
#endif

        DDLogInfo(@"Camment SDK has started");

#ifdef INTERNALSDK
        [self setupTweaks];
#endif

        self.connectionAvailable = YES;
        self.connectionReachibility = [CMConnectionReachability reachabilityForInternetConnection];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

        [self updateInterfaceWithReachability:self.connectionReachibility];
        [self.connectionReachibility startNotifier];
    }

    return self;
}

- (void)reachabilityChanged:(NSNotification *)reachabilityChanged {
    CMConnectionReachability *curReach = [reachabilityChanged object];
    if ([curReach isKindOfClass:[CMConnectionReachability class]]) {
        [self updateInterfaceWithReachability:curReach];
    }
}

- (void)updateInterfaceWithReachability:(CMConnectionReachability *)reachability {
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionAvailable = netStatus != NotReachable;
    if (connectionAvailable && connectionAvailable != self.connectionAvailable) {
        connectionAvailable = YES;
        if (![CMStore instance].isSignedIn) {
            [self tryRestoreLastSession];
        }
    }

    self.connectionAvailable = connectionAvailable;
}

- (void)dealloc {
    [self.connectionReachibility stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        volumeTweak.currentValue = @10.0f;
        volumeTweak.name = @"Volume (%)";
        [videoSettingsCollection addTweak:volumeTweak];
    }

    DDLogInfo(@"Tweaks have been configured");
}

- (void)configureWithApiKey:(NSString *)apiKey {
    [CMStore instance].apiKey = apiKey;
    [self configure];
    [self launch];
    [self tryRestoreLastSession];
}

- (void)tryRestoreLastSession {

    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
    CMCammentIdentity *identity = [CMCammentFacebookIdentity identityWithFBSDKAccessToken:token];

    [self connectUserWithIdentity:identity
                          success:^{
                          }
                            error:^(NSError *error) {
                            }];
}

- (void)connectUserWithIdentity:(CMCammentIdentity *)identity
                        success:(void (^ _Nullable)())successBlock
                          error:(void (^ _Nullable)(NSError *error))errorBlock {

    if ([identity isKindOfClass:[CMCammentFacebookIdentity class]]) {
        [self.authService configureWithProvider:[CMCognitoFacebookAuthProvider new]];
        CMCammentFacebookIdentity *cammentFacebookIdentity = (CMCammentFacebookIdentity *) identity;
        [FBSDKAccessToken setCurrentAccessToken:cammentFacebookIdentity.fbsdkAccessToken];
        [self signInUserWithSuccess:successBlock error:errorBlock];
    } else {
        DDLogError(@"Trying to connect unknown identity %@", [identity class]);
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
                NSLog(@"%@", cognitoUserId);
                [[CMStore instance] setCognitoUserId:cognitoUserId];
                [[CMStore instance] setFacebookUserId:[FBSDKAccessToken currentAccessToken].userID];
                CMUser *currentUser = [[[[CMUserBuilder new]
                        withCognitoUserId:cognitoUserId]
                        withStatus:CMUserStatusOnline]
                        build];
                [[CMStore instance] setCurrentUser:currentUser];
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

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
            initWithGraphPath:@"/me"
                   parameters:@{@"fields": @"email"}
                   HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
            id result,
            NSError *error) {
        if (result && !error) {
            [CMStore instance].email = (NSString *) [result valueForKey:@"email"];
        }
    }];

    CMUserBuilder *userBuilder = [CMStore instance].currentUser ? [CMUserBuilder userFromExistingUser:[CMStore instance].currentUser] : [CMUserBuilder new];

    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    if (!profile) {
        DDLogVerbose(@"FB profile not found");
        return;
    }

    [CMStore instance].facebookUserId = profile.userID;

    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    if (profile.userID) {
        userInfo[@"facebookId"] = profile.userID;
        userBuilder = [userBuilder withFbUserId:profile.userID];
    }

    if (profile.name) {
        userInfo[@"name"] = profile.name;
        userBuilder = [userBuilder withUsername:profile.name];
    }

    NSURL *imageUrl = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(270, 270)];
    if (imageUrl) {
        userInfo[@"picture"] = imageUrl.absoluteString;
        userBuilder = [userBuilder withUserPhoto:imageUrl.absoluteString];
    }

    [[CMStore instance] setCurrentUser:[userBuilder build]];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                       options:0
                                                         error:&error];
    if (!jsonData) {return;}

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    if (!jsonString) {return;}

    CMAPIUserinfoInRequest *userinfoInRequest = [CMAPIUserinfoInRequest new];
    userinfoInRequest.userinfojson = jsonString;

    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    [[client userinfoPost:userinfoInRequest] continueWithBlock:^id(AWSTask<id> *t) {
        if (!t.error) {
            DDLogVerbose(@"CMUser info has been updated with data %@", userInfo);
        }
        return nil;
    }];
}

- (void)launch {
}

- (void)configure {
    [[AWSDDLog sharedInstance] setLogLevel:AWSDDLogLevelAll];
    [AWSDDLog addLogger:AWSDDTTYLogger.sharedInstance];
    [FBSDKSettings setAppID:[CMAppConfig instance].fbAppId];
    [[CMAnalytics instance] configureAWSMobileAnalytics];
    self.authService = [[CMCognitoAuthService alloc] init];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInfo)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    [[CMAPIDevcammentClient defaultAPIClient] setAPIKey:[CMStore instance].apiKey];
}

- (void)configureIoTListener:(NSString *)userId {

    CMServerListenerCredentials *credentials = [CMServerListenerCredentials defaultCredentials];

    CMServerListener *listener = [CMServerListener instance];
    [listener renewCredentials:credentials];
    [listener.messageSubject subscribeNext:^(CMServerMessage *message) {
        [message matchInvitation:^(CMInvitation *invitation) {
            if (![invitation.userGroupUuid isEqualToString:[CMStore instance].activeGroup.uuid]
                    && [invitation.invitedUserFacebookId isEqualToString:[CMStore instance].facebookUserId]
                    && ![invitation.invitationIssuer.fbUserId isEqualToString:[CMStore instance].facebookUserId]) {
                [self presentChatInvitation:invitation];
            }
        }                camment:^(CMCamment *camment) {
        }             userJoined:^(CMUserJoinedMessage *userJoinedMessage) {
        }         cammentDeleted:^(CMCammentDeletedMessage *cammentDeletedMessage) {
        }];
    }];
}

- (void)presentChatInvitation:(CMInvitation *)invitation {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    NSString *username = invitation.invitationIssuer.username ?: @"Your friend";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"User invited you to a private chat"), username]
                                                                             message:CMLocalized(@"Would you like to join the conversation?")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Join") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self handleUserJoinedToGroup:invitation.userGroupUuid];

        if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didAcceptInvitationToShow:)]) {
            CMShowMetadata *metadata = [CMShowMetadata new];
            metadata.uuid = invitation.showUuid;
            [self.sdkDelegate didAcceptInvitationToShow:metadata];
        }
        [[self acceptInvitation:invitation] continueWithBlock:^id(AWSTask<id> *t) {
            return nil;
        }];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

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

- (AWSTask *)acceptInvitation:(CMInvitation *)invitation {
    if (invitation.invitationKey == nil) { return [AWSTask taskWithError:[NSError errorWithDomain:@"tv.camment.ios" code:0 userInfo:nil]]; }

    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    CMAPIAcceptInvitationRequest *invitationRequest = [CMAPIAcceptInvitationRequest new];
    invitationRequest.invitationKey = invitation.invitationKey;
    return [client usergroupsGroupUuidInvitationsPut:invitation.userGroupUuid
                                                body:invitationRequest];
}

- (void)handleUserJoinedToGroup:(NSString *)groupId {
    DDLogInfo(@"Join group id %@", groupId);
    CMUsersGroup *usersGroup = [[[CMUsersGroupBuilder new] withUuid:groupId] build];
    [[CMStore instance] setActiveGroup:usersGroup];
    [[[CMStore instance] reloadActiveGroupSubject] sendNext:@YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DDLogInfo(@"applicationDidBecomeActive hook has been installed");
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDLogInfo(@"didFinishLaunchingWithOptions hook has been installed");
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];

    if ([urlComponents.scheme isEqualToString:@"camment"]
            && [urlComponents.host isEqualToString:@"group"])
    {
        NSString *groupUuid = [urlComponents.path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
        if (groupUuid.length > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentChatInvitation:[[[[CMInvitationBuilder alloc] init]
                        withUserGroupUuid:groupUuid]
                        build]];
            });

            return YES;
        }
    }

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
    ];
}

@end
