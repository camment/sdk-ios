//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

@import CoreText;
#import <ReactiveObjC/ReactiveObjC.h>
#import "CammentSDK.h"
#import "CMStore.h"
#import "CMAnalytics.h"
#import "CMAWSServicesFactory.h"
#import "CMServerListenerCredentials.h"
#import "CMServerListener.h"
#import "CMServerMessage.h"
#import "CMUsersGroupBuilder.h"
#import "CMAPIDevcammentClient.h"
#import "CMAppConfig.h"
#import "CMInvitationViewController.h"
#import "CMUserBuilder.h"
#import "CMInvitationBuilder.h"
#import "CMConnectionReachability.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMAuthInteractor.h"
#import "MBProgressHUD.h"

#import "CMGroupManagementInteractorInput.h"
#import "CMGroupManagementInteractor.h"
#import "CMServerMessage+TypeMatching.h"
#import "GVUserDefaults.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "AWSIotDataManager.h"
#import "NSArray+RacSequence.h"
#import "AWSCognito.h"
#import "CMInternalCammentSDKProtocol.h"
#import "CMUserSessionController.h"
#import "CMCognitoFacebookAuthProvider.h"

@interface CammentSDK () <CMGroupManagementInteractorOutput, CMInternalCammentSDKProtocol>

@property(nonatomic, strong) CMAWSServicesFactory *awsServicesFactory;
@property(nonatomic) BOOL connectionAvailable;

@property(nonatomic) id <CMAuthInteractorInput> authInteractor;
@property(nonatomic) id <CMGroupManagementInteractorInput> groupManagmentInteractor;

@property(nonatomic) NSOperationQueue *onSignedInOperationsQueue;
@property(nonatomic) NSOperationQueue *onSDKHasBeenConfiguredQueue;

@property(nonatomic, strong) CMConnectionReachability *connectionReachibility;
@property(nonatomic, strong) RACDisposable *iotSubscriptionDisposable;

@property(nonatomic, strong) DDFileLogger *fileLogger;

@property(nonatomic, strong) CMUserSessionController *userSessionController;
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

        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        self.fileLogger = [[DDFileLogger alloc] init]; // File Logger
        self.fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        self.fileLogger.logFileManager.maximumNumberOfLogFiles = 3;
        [DDLog addLogger:self.fileLogger];

#ifdef INTERNALSDK
        [[CMStore instance] setupTweaks];
#else
        [CMStore instance].isOfflineMode = NO;
#endif

        [[CMAnalytics instance] configureAWSMobileAnalytics];

        self.groupManagmentInteractor = [CMGroupManagementInteractor new];
        [(CMGroupManagementInteractor *) self.groupManagmentInteractor setOutput:self];

        self.onSignedInOperationsQueue = [[NSOperationQueue alloc] init];
        self.onSignedInOperationsQueue.maxConcurrentOperationCount = 1;

        self.onSDKHasBeenConfiguredQueue = [[NSOperationQueue alloc] init];
        self.onSDKHasBeenConfiguredQueue.maxConcurrentOperationCount = 1;
        [self.onSDKHasBeenConfiguredQueue setSuspended:YES];

        self.connectionAvailable = YES;
        self.connectionReachibility = [CMConnectionReachability reachabilityForInternetConnection];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(identityIdDidChange:)
                                                     name:AWSCognitoIdentityIdChangedNotification
                                                   object:nil];

        [self clearTmpDirectory];

        DDLogDeveloperInfo(@"Camment SDK instantiated");
    }

    return self;
}

- (void)configureWithApiKey:(NSString *_Nonnull)apiKey
           identityProvider:(id <CMIdentityProvider> _Nonnull)identityProvider {
    [CMAppConfig instance].apiKey = apiKey;

    self.awsServicesFactory = [[CMAWSServicesFactory alloc] initWithAppConfig:[CMAppConfig instance]];


    self.userSessionController = [CMUserSessionController registerInstanceWithUser:nil
                                                                            tokens:nil
                                                        cognitoCredentialsProvider:self.awsServicesFactory.cognitoCredentialsProvider
                                                        authentificationInteractor:[[CMAuthInteractor alloc] initWithIdentityProvider:identityProvider]
                                                   cognitoFacebookIdentityProvider:self.awsServicesFactory.cognitoFacebookIdentityProvider
                                                           authChangedEventSubject:[CMStore instance].authentificationStatusSubject];

    if ([GVUserDefaults standardUserDefaults].isFirstSDKLaunch) {
        [self.userSessionController endSession];
        [GVUserDefaults standardUserDefaults].isFirstSDKLaunch = NO;
    }

    [self.onSDKHasBeenConfiguredQueue addOperationWithBlock:^{
        [self.awsServicesFactory configureAWSServices:self.awsServicesFactory.cognitoCredentialsProvider];
        [self configureIoTListeneWithNewIdentity:self.awsServicesFactory.cognitoCredentialsProvider.identityId];
        DDLogDeveloperInfo(@"all services are up and running");
        [self checkIfDeferredDeepLinkExists];
    }];

    [self wakeUpUserSession];
}

- (void)wakeUpUserSession {
    [[self.userSessionController refreshSession:NO]
            continueWithBlock:^id(AWSTask<id> *task) {
                if (task.error) {
                    DDLogError(@"Error on signing in at configureWithApiKey:identityProvider: method %@", task.error);
                    return nil;
                } else {
                    DDLogDeveloperInfo(@"user session is ready, continue with SDK configuration");
                    [self.onSDKHasBeenConfiguredQueue setSuspended:NO];
                }

                return nil;
            }];
}

- (void)identityIdDidChange:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    DDLogInfo(@"identity changed from %@ to %@",
            [userInfo objectForKey:AWSCognitoNotificationPreviousId],
            [userInfo objectForKey:AWSCognitoNotificationNewId]);
    NSString *newIdentity = [userInfo objectForKey:AWSCognitoNotificationNewId];
    NSString *oldIdentity = [userInfo objectForKey:AWSCognitoNotificationPreviousId];

    [self identityHasChangedOldIdentity:oldIdentity newIdentity:newIdentity];
}

- (void)identityHasChangedOldIdentity:(NSString *)oldIdentity newIdentity:(NSString *)newIdentity {
    if (newIdentity == nil) {return;}

    [[CMAnalytics instance] setMixpanelID:newIdentity];

    if (oldIdentity) {
        if ([[[CMStore instance].activeGroup ownerCognitoUserId] isEqualToString:oldIdentity]) {
            [CMStore instance].activeGroup = [[[CMUsersGroupBuilder
                    usersGroupFromExistingUsersGroup:
                            [CMStore instance].activeGroup]
                    withOwnerCognitoUserId:newIdentity]
                    build];
        }

        [CMStore instance].activeGroupUsers = [[CMStore instance].activeGroupUsers map:^CMUser *(CMUser *oldUser) {
            if ([[oldUser cognitoUserId] isEqualToString:oldIdentity]) {
                return [[[CMUserBuilder userFromExistingUser:oldUser]
                        withCognitoUserId:newIdentity]
                        build];
            }

            return oldUser;
        }];

        [CMStore instance].userGroups = [[CMStore instance].userGroups map:^CMUsersGroup *(CMUsersGroup *oldGroup) {
            if ([oldGroup.ownerCognitoUserId isEqualToString:oldIdentity]) {
                return [[[CMUsersGroupBuilder usersGroupFromExistingUsersGroup:oldGroup]
                        withOwnerCognitoUserId:newIdentity] build];
            }
            return oldGroup;
        }];
    }


    if (_awsServicesFactory.cognitoHasBeenConfigured) {
        [self syncCognitoProfiles:oldIdentity newIdentity:newIdentity];
        [self configureIoTListeneWithNewIdentity:newIdentity];
    }
}

- (void)syncCognitoProfiles:(NSString *)oldIdentity newIdentity:(NSString *)newIdentity {
    if (!oldIdentity || !newIdentity || [oldIdentity isEqualToString:newIdentity]) {
        return;
    }
    
    AWSCognito *cognito = [AWSCognito CognitoForKey:CMCognitoName];
    
    AWSCognitoDataset *dataset = [cognito openOrCreateDataset:@"identitySet"];
    [dataset setConflictHandler:^AWSCognitoResolvedConflict *(NSString *datasetName, AWSCognitoConflict *conflict) {
        return [conflict resolveWithLocalRecord];
    }];
    
    [[[[dataset synchronize] continueWithBlock:^id(AWSTask<id> *t) {
        [dataset setString:oldIdentity forKey:newIdentity];
        
        return [dataset synchronize];
    }] continueWithBlock:^id(AWSTask<id> *t) {
        return [[CMAPIDevcammentClient defaultAPIClient] meUuidPut];
    }] continueWithBlock:^id _Nullable(AWSTask *_Nonnull t) {
        if (t.error) {
            DDLogError(@"%@", t);
        } else {
            DDLogInfo(@"Profile switched from %@  to %@", oldIdentity, newIdentity);
        }
        return nil;
    }];
}

- (void)configure {
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
            [self updateInterfaceWithReachability:self.connectionReachibility];
            [self.connectionReachibility startNotifier];
        }
    }];
}

- (void)loadAssets {
    NSArray *customFonts = @[
            @"Nunito-Medium.ttf"
    ];
    [customFonts map:^id(NSString *fileName) {
        NSString *filePath = [[NSBundle cammentSDKBundle] pathForResource:fileName ofType:nil];
        if (!filePath) {return nil;}

        NSData *inData = [NSData dataWithContentsOfFile:filePath];
        if (!inData) {return nil;}

        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef) inData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (!CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            DDLogError(@"Failed to load font: %@", errorDescription);
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

        if (self.userSessionController.userAuthentificationState == CMCammentUserNotAuthentificated) {
            DDLogDeveloperInfo(@"Reachability changed, updating user session..");
            [self wakeUpUserSession];
        }
    }

    self.connectionAvailable = connectionAvailable;
}

- (void)dealloc {
    [self.connectionReachibility stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureIoTListeneWithNewIdentity:(NSString *)newIdentity {

    CMServerListener *listener = [CMServerListener instance];
    [listener redubscribeToNewIdentity:newIdentity];

    if (!self.iotSubscriptionDisposable) {
        self.iotSubscriptionDisposable = [listener.messageSubject subscribeNext:^(CMServerMessage *message) {

            [message matchInvitation:^(CMInvitation *invitation) {
                if (![invitation.userGroupUuid isEqualToString:[CMStore instance].activeGroup.uuid]
                        && [invitation.invitedUserFacebookId isEqualToString:self.userSessionController.user.fbUserId]
                        && ![invitation.invitationIssuer.fbUserId isEqualToString:self.userSessionController.user.fbUserId]) {
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
                                                      handler:^(UIAlertAction *action) {
                                                      }]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]) {
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
        id <CMInternalCammentSDKProtocol> SDK = (id) [CammentSDK instance];
        [SDK openURL:url];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                      }]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sdkUIDelegate cammentSDKWantsPresentViewController:alertController];
        });
    } else {
        DDLogError(@"CammentSDK UI delegate is nil or not implemented");
    }
}

- (void)presentLoginSuggestion:(NSString *)reason {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"Login with your Facebook account?")
                                                                             message:reason
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Login") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self.userSessionController refreshSession:YES] continueWithBlock:^id(AWSTask<id> *task) {
                if (task.error) {
                    [self.onSignedInOperationsQueue cancelAllOperations];
                } else {
                    [self.onSignedInOperationsQueue setSuspended:NO];
                }
                return nil;
            }];
        });
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.onSignedInOperationsQueue cancelAllOperations];
    }]];

    if (self.sdkUIDelegate && [self.sdkUIDelegate respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]) {
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
        CMAPIShowUuid *showUuid = [CMAPIShowUuid new];
        showUuid.showUuid = invitation.showUuid;
        return [client usergroupsGroupUuidUsersPost:invitation.userGroupUuid body:showUuid];
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

- (void)refreshUserIdentity:(BOOL)forceSignin {
    [[self.userSessionController refreshSession:forceSignin]
            continueWithBlock:^id(AWSTask<id> *t) {
                return nil;
            }];
}

- (void)logOut {
    [self.userSessionController endSession];
    [[CMStore instance] cleanUp];

    [self refreshUserIdentity:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DDLogInfo(@"applicationDidBecomeActive hook has been installed");

    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    if (pb.URL) {

        NSURLComponents *components = [NSURLComponents componentsWithURL:pb.URL resolvingAgainstBaseURL:NO];
        if (![components.host isEqualToString:@"camment.sportacam.com"]) {return;}
        [self presentOpenURLSuggestion:pb.URL];
        [pb setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDLogInfo(@"didFinishLaunchingWithOptions hook has been installed");

#ifdef DEBUG
    [AWSDDLog sharedInstance].logLevel = AWSLogLevelDebug;
    [AWSDDLog addLogger:[AWSDDTTYLogger sharedInstance]];
#endif

    [[CMAnalytics instance] configureMixpanelAnalytics];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventAppStart];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    return YES;
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

- (BOOL)verifyURL:(NSURL *)url {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];

    if ([urlComponents.scheme isEqualToString:@"camment"]
            && [urlComponents.host isEqualToString:@"group"]) {
        NSArray *components = [urlComponents.path pathComponents];
        if (components.count < 4) {return NO;}

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

        return YES;
    }

    return NO;
}


- (void)verifyInvitation:(CMInvitation *)invitation {
    if (!invitation || !invitation.userGroupUuid) {return;}

    if ([self.onSDKHasBeenConfiguredQueue isSuspended]) {
        @weakify(self);
        [self.onSDKHasBeenConfiguredQueue addOperationWithBlock:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self verifyInvitation:invitation];
            });
        }];
        return;
    }

    if (self.userSessionController.userAuthentificationState == CMCammentUserAuthentificatedAsKnownUser) {
        //for external invitations key should be nil for now
        NSString *invitationKey = nil;
        CMInvitation *invitationWithUpdatedKey = [[[CMInvitationBuilder
                invitationFromExistingInvitation:invitation]
                withInvitationKey:invitationKey] build];
        NSString *groupUuid = invitation.userGroupUuid;
        AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidGet:groupUuid];

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
                    if ([usergroup.userCognitoIdentityId isEqualToString:self.userSessionController.user.cognitoUserId]) {
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

- (void)clearTmpDirectory {
    NSArray *tmpDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL] ?: @[];
    tmpDirectory = [tmpDirectory.rac_sequence filter:^BOOL(NSString *_Nullable value) {
        return [value hasSuffix:@".mp4"];
    }].array ?: @[];
    DDLogInfo(@"Cleaned up %d cache files", tmpDirectory.count);
    for (NSString *file in tmpDirectory) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:&error];
        if (error) {
            DDLogError(@"error on cleaning up cache", error);
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self verifyURL:url];
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)application annotation:(id)annotation {
    return [self verifyURL:url];
}

- (void)openURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];

    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:url options:@{}
           completionHandler:^(BOOL success) {
               DDLogVerbose(@"Open %@: %d", url, success);
           }];
    } else {
        BOOL success = [application openURL:url];
        DDLogVerbose(@"Open %@: %d", url, success);
    }
}

@end
