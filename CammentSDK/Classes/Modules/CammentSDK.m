//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

@import CoreText;
#import <ReactiveObjC/ReactiveObjC.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CammentSDK.h"
#import "CMStore.h"
#import "CMAnalytics.h"
#import "CMCognitoAuthService.h"
#import "CMCognitoFacebookAuthProvider.h"
#import "CMServerListenerCredentials.h"
#import "CMServerListener.h"
#import "CMPresentationBuilder.h"
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
#import "CMAuthInteractor.h"
#import "MBProgressHUD.h"

#import "FBTweak.h"
#import "FBTweakStore.h"
#import "FBTweakCollection.h"
#import "CMInvitationInteractorInput.h"
#import "CMGroupManagementInteractorInput.h"
#import "CMGroupManagementInteractor.h"
#import "CMServerMessage+TypeMatching.h"
#import "NSString+MD5.h"
#import "GVUserDefaults.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "AWSIotDataManager.h"
#import "Mixpanel.h"
#import "NSArray+RacSequence.h"

@interface CammentSDK () <CMAuthInteractorOutput, CMGroupManagementInteractorOutput>

@property(nonatomic, strong) CMCognitoAuthService *authService;
@property(nonatomic) BOOL connectionAvailable;

@property(nonatomic) id <CMAuthInteractorInput> authInteractor;
@property(nonatomic) id <CMGroupManagementInteractorInput> groupManagmentInteractor;

@property(nonatomic) NSOperationQueue *onSignedInOperationsQueue;

@property(nonatomic, strong) CMConnectionReachability *connectionReachibility;
@property(nonatomic, strong) RACDisposable *iotSubscriptionDisposable;
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
        [self loadAssets];
#ifdef DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
#else
        [DDLog addLogger:[[DDFileLogger alloc] init]];
#endif

        DDLogInfo(@"Camment SDK has started");

#ifdef INTERNALSDK
        [[CMStore instance] setupTweaks];
#endif
        self.authInteractor = [CMAuthInteractor new];
        [(CMAuthInteractor *) self.authInteractor setOutput:self];

        self.groupManagmentInteractor = [CMGroupManagementInteractor new];
        [(CMGroupManagementInteractor *) self.groupManagmentInteractor setOutput:self];

        self.onSignedInOperationsQueue = [[NSOperationQueue alloc] init];
        self.onSignedInOperationsQueue.maxConcurrentOperationCount = 1;

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

- (void)loadAssets {
    NSArray *customFonts = @[
            @"Nunito-Medium.ttf"
    ];
    [customFonts map:^id(NSString *fileName) {
        NSString *filePath = [[NSBundle cammentSDKBundle] pathForResource:fileName ofType:nil];
        if (!filePath) { return nil; }

        NSData *inData = [NSData dataWithContentsOfFile:filePath];
        if (!inData) { return nil; }

        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            DDLogInfo(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);

        return nil;
    }];

    DDLogInfo(@"Fonts loaded");
    DDLogInfo(@"%@", [UIFont familyNames]);
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

- (void)configureWithApiKey:(NSString *)apiKey {
    [CMStore instance].apiKey = apiKey;
    [self configure];
    [self launch];
    @weakify(self);
    
    [[RACObserve([CMStore instance], isOfflineMode) deliverOnMainThread] subscribeNext:^(NSNumber *isOfflineMode) {
        @strongify(self);
        if (isOfflineMode.boolValue) {
            [self.connectionReachibility stopNotifier];
            
            CMServerListener *listener = [CMServerListener instance];
            [self.iotSubscriptionDisposable dispose];
            [[listener dataManager] disconnect];
            
            return;
        } else {
            [self.connectionReachibility startNotifier];
            [[self tryRestoreLastSession] subscribeCompleted:^{
                [self checkIfDeferredDeepLinkExists];
            }];
        }
    }];
}

- (RACSignal *)tryRestoreLastSession {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
        [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
        CMCammentIdentity *identity = [CMCammentFacebookIdentity identityWithFBSDKAccessToken:token];

        [self connectUserWithIdentity:identity
                              success:^{
                                  [subscriber sendCompleted];
                              }
                                error:^(NSError *error) {
                                    [subscriber sendError:error];
                                }];
        return nil;
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
                [[CMAnalytics instance] setMixpanelID:cognitoUserId];
                CMUser *currentUser = [[[[[CMUserBuilder userFromExistingUser:[CMStore instance].currentUser]
                                          withCognitoUserId:cognitoUserId]
                                         withFbUserId:[FBSDKAccessToken currentAccessToken].userID]
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
                    [self configureIoTListener:[CMStore instance].currentUser.cognitoUserId];
                    if ([CMStore instance].isFBConnected) {
                        [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventFbSignin];
                    }
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
            NSString *email = (NSString *) [result valueForKey:@"email"];
            [CMStore instance].currentUser = [[[CMUserBuilder userFromExistingUser:[CMStore instance].currentUser]
                                              withEmail:email]
                                              build];
        }
    }];

    CMUserBuilder *userBuilder = [CMStore instance].currentUser ? [CMUserBuilder userFromExistingUser:[CMStore instance].currentUser] : [CMUserBuilder new];

    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    if (!profile) {
        DDLogVerbose(@"FB profile not found");
        return;
    }

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
    [self.iotSubscriptionDisposable dispose];
    self.iotSubscriptionDisposable = [listener.messageSubject subscribeNext:^(CMServerMessage *message) {

        [message matchInvitation:^(CMInvitation *invitation) {
            if (![invitation.userGroupUuid isEqualToString:[CMStore instance].activeGroup.uuid]
                    && [invitation.invitedUserFacebookId isEqualToString:[CMStore instance].currentUser.fbUserId]
                    && ![invitation.invitationIssuer.fbUserId isEqualToString:[CMStore instance].currentUser.fbUserId]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentChatInvitation:invitation];
                });
            }
        }];

        [message matchMembershipRequest:^(CMMembershipRequestMessage *membershipRequestMessage) {
            [self presentMembershipRequestAlert:membershipRequestMessage];
        }];

        [message matchMembershipAccepted:^(CMMembershipAcceptedMessage *membershipAcceptedMessage) {
            [self presentMembershipAcceptedAlert:membershipAcceptedMessage];
        }];
    }];
}

- (void)presentMembershipAcceptedAlert:(CMMembershipAcceptedMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self joinUserToGroup:message.group.uuid];

        CMShowMetadata *metadata = [CMShowMetadata new];
        CMShow *show = message.show;
        if (show) {
            metadata.uuid = show.uuid;
        }

        if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didJoinToShow:)]) {
            [self.sdkDelegate didJoinToShow:metadata];
        } else if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didAcceptInvitationToShow:)]) {
            [self.sdkDelegate didAcceptInvitationToShow:metadata];
        }

        [self showHud:CMLocalized(@"You have joined the private chat!") hideAfter:2];
    });
}

- (void)showHud:(NSString *)status hideAfter:(NSUInteger)delay {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = status;
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)presentMembershipRequestAlert:(CMMembershipRequestMessage *)message {

    CMUsersGroup *group = message.group;
    CMUser *user = message.joiningUser;

    NSString *username = user.username ?: @"Your friend";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"User wants to join the group"), username]
                                                                             message:CMLocalized(@"Do you accept the join request?")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didAcceptJoiningRequest:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CMShowMetadata *metadata = [CMShowMetadata new];
                metadata.uuid = message.show.uuid;
                [self.sdkDelegate didAcceptJoiningRequest:metadata];
            });
        }
        [self joinUserToGroup:group.uuid];
        [self.groupManagmentInteractor replyWithJoiningPermissionForUser:user
                                                                   group:group
                                                         isAllowedToJoin:YES
                                                                    show:message.show];
        [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventAcceptJoinRequest];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.groupManagmentInteractor replyWithJoiningPermissionForUser:user
                                                                   group:group
                                                         isAllowedToJoin:NO
                                                                    show:message.show];
        [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventDeclineJoinRequest];
    }]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sdkUIDelegate cammentSDKWantsPresentViewController:alertController];
        });
    } else {
        DDLogError(@"CammentSDK UI delegate is nil or not implemented");
    }
}

- (void)presentChatInvitation:(CMInvitation *)invitation {

    NSString *username = invitation.invitationIssuer.username ?: @"Your friend";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"User invited you to a private chat"), username]
                                                                             message:CMLocalized(@"Would you like to join the conversation?")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Join") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        CMShowMetadata *metadata = [CMShowMetadata new];;
        metadata.uuid = invitation.showUuid;

        if (self.sdkDelegate && [self.sdkDelegate respondsToSelector:@selector(didOpenInvitationToShow:)]) {
            [self.sdkDelegate didOpenInvitationToShow:metadata];
        }

        [[self acceptInvitation:invitation] continueWithBlock:^id(AWSTask<id> *t) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (t.error) {
                    [self showHud:CMLocalized(@"You are not allowed to join this group") hideAfter:2];
                }
            });
            return nil;
        }];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {}]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sdkUIDelegate cammentSDKWantsPresentViewController:alertController];
        });
    } else {
        DDLogError(@"CammentSDK UI delegate is nil or not implemented");
    }
}

- (void)presentOpenURLSuggestion:(NSURL *)url {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"We found a link in your clipboard")]
                                                                             message:CMLocalized(@"Would you like to open it and join the group? It will redirect you to your web browser first.")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Join") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {}]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sdkUIDelegate cammentSDKWantsPresentViewController:alertController];
        });
    } else {
        DDLogError(@"CammentSDK UI delegate is nil or not implemented");
    }
}

- (void)presentLoginSuggestion:(NSString *)reason {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"Login with your Facebook account?")
                                                                             message:reason
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Login") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.authInteractor signInWithFacebookProvider:rootViewController.topVisibleViewController];
        });
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.onSignedInOperationsQueue cancelAllOperations];
    }]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sdkUIDelegate cammentSDKWantsPresentViewController:alertController];
        });
    } else {
        DDLogError(@"CammentSDK UI delegate is nil or not implemented");
    }
}

- (AWSTask *)acceptInvitation:(CMInvitation *)invitation {
    if (invitation.invitationKey == nil) {
        CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
        return [client usergroupsGroupUuidUsersPost:invitation.userGroupUuid showUuid:invitation.showUuid];
    }

    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    CMAPIAcceptInvitationRequest *invitationRequest = [CMAPIAcceptInvitationRequest new];
    invitationRequest.invitationKey = invitation.invitationKey;
    return [client usergroupsGroupUuidInvitationsPut:invitation.userGroupUuid
                                                body:invitationRequest];
}

- (void)joinUserToGroup:(NSString *)groupId {
    DDLogInfo(@"Join group id %@", groupId);
    if (![groupId isEqualToString:[CMStore instance].activeGroup.uuid]) {
        CMUsersGroup *usersGroup = [[[CMUsersGroupBuilder new] withUuid:groupId] build];
        [[CMStore instance] setActiveGroup:usersGroup];
        [[[CMStore instance] reloadActiveGroupSubject] sendNext:@YES];
        [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventJoinGroup];
    } else {
        [[CMStore instance].userHasJoinedSignal sendNext:@YES];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DDLogInfo(@"applicationDidBecomeActive hook has been installed");
    [FBSDKAppEvents activateApp];

    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    if (pb.URL) {

        NSURLComponents *components = [NSURLComponents componentsWithURL:pb.URL resolvingAgainstBaseURL:NO];
        if (![components.host isEqualToString:@"camment.sportacam.com"]) { return; }
        [self presentOpenURLSuggestion:pb.URL];
        [pb setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDLogInfo(@"didFinishLaunchingWithOptions hook has been installed");
    [[CMAnalytics instance] configureMixpanelAnalytics];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventAppStart];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [self verifyURL:url];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
    ];
}

- (void)checkIfDeferredDeepLinkExists {
    GVUserDefaults *userDefaults = [GVUserDefaults standardUserDefaults];
    if (userDefaults.isInstallationDeeplinkChecked) {return;}
    userDefaults.isInstallationDeeplinkChecked = YES;

    NSString *systemVersion = [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *deeplinkHash = [NSString stringWithFormat:@"iOS|%@", systemVersion];
    [[[CMAPIDevcammentClient defaultAPIClient] deferredDeeplinkGet:deeplinkHash
                                                                os:@"ios"]
            continueWithBlock:^id(AWSTask<id> *task) {
                if ([task.result isKindOfClass:[CMAPIDeeplink class]]) {
                    CMAPIDeeplink *deeplink = task.result;
                    NSURL *deeplinkURL = deeplink.url ? [[NSURL alloc] initWithString:deeplink.url] : nil;
                    if (deeplinkURL) {
                        [self verifyURL:deeplinkURL];
                    }
                }
                return nil;
            }];
}

- (void)verifyURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];

    if ([urlComponents.scheme isEqualToString:@"camment"]
            && [urlComponents.host isEqualToString:@"group"]) {
        NSArray *components = [urlComponents.path pathComponents];
        if (components.count < 4) { return; }
        
        NSString *groupUuid = components[1];
        NSString *showUuid = components[3];
        if (groupUuid.length > 0 && showUuid.length > 0) {
            [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventOpenDeeplink];
            dispatch_async(dispatch_get_main_queue(), ^{
                CMInvitation *invitation = [[[[[CMInvitationBuilder alloc] init]
                                             withUserGroupUuid:groupUuid]
                                            withShowUuid:showUuid]
                                            build];
                [self verifyInvitation:invitation];
            });
        }
    }
}


- (void)verifyInvitation:(CMInvitation *)invitation {
    if (!invitation || !invitation.userGroupUuid) { return; }

    if ([CMStore instance].isFBConnected) {
        //for external invitations key should be nil for now
        NSString *invitationKey = nil;
        CMInvitation *invitationWithUpdatedKey = [[[CMInvitationBuilder
                                                    invitationFromExistingInvitation:invitation]
                                                   withInvitationKey:invitationKey] build];
        NSString *groupUuid = invitation.userGroupUuid;
        AWSTask * task =[[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidGet:groupUuid];

        __weak typeof(self) weakSelf = self;
        dispatch_block_t presentChatInvitationBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf presentChatInvitation:invitationWithUpdatedKey];
            });
        };

        if (task) {
            [task continueWithBlock:^id(AWSTask<id> *t) {
                if (!t.error && [t.result isKindOfClass:[CMAPIUsergroup class]]) {
                    CMAPIUsergroup *usergroup = t.result;
                    if ([usergroup.userCognitoIdentityId isEqualToString:[CMStore instance].currentUser.cognitoUserId]) {
                        CMUsersGroup *group = [[[[[CMUsersGroupBuilder new]
                                withUuid:invitation.userGroupUuid]
                                withOwnerCognitoUserId:usergroup.userCognitoIdentityId]
                                withTimestamp:usergroup.timestamp]
                                build];
                        CMShow *show = [[CMShow alloc] initWithUuid:invitation.showUuid
                                                                url:nil
                                                          thumbnail:nil
                                                           showType:[CMShowType videoWithShow:nil]
                                                           startsAt:nil];

                        CMMembershipAcceptedMessage *message = [[CMMembershipAcceptedMessage alloc] initWithGroup:group show:show];
                        [weakSelf presentMembershipAcceptedAlert:message];
                    } else {
                        presentChatInvitationBlock();
                    }
                }
                return nil;
            }];
        } else {
            presentChatInvitationBlock();
        }


    } else {
        [self.onSignedInOperationsQueue setSuspended:YES];
        @weakify(self);
        [self.onSignedInOperationsQueue addOperationWithBlock:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self verifyInvitation:invitation];
            });
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentLoginSuggestion:@"You will join the group right after this"];
        });
    }
}

- (void)authInteractorDidSignedIn {
    CMCammentFacebookIdentity *fbIdentity = [CMCammentFacebookIdentity identityWithFBSDKAccessToken:[FBSDKAccessToken currentAccessToken]];
    [[CammentSDK instance] connectUserWithIdentity:fbIdentity
                                           success:^{
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self.onSignedInOperationsQueue setSuspended:NO];
                                               });
                                           }
                                             error:^(NSError *error) {
                                             }];
}

- (void)authInteractorFailedToSignIn:(NSError *)error {

}

- (void)logout {
    CMServerListener *listener = [CMServerListener instance];
    [self.iotSubscriptionDisposable dispose];
    [[listener dataManager] disconnect];

    [[FBSDKLoginManager new] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [self.authService signOut];
    [[CMStore instance] cleanUp];
    [[self tryRestoreLastSession] subscribeCompleted:^{}];
}


@end
