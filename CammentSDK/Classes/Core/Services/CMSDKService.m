//
//  CMSDKService.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 22.11.2017.
//

@import CoreText;
@import AVFoundation;
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMSDKService.h"
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
#import "CMInvitationBuilder.h"
#import "CMConnectionReachability.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMAuthInteractor.h"

#import "CMGroupManagementInteractorInput.h"
#import "CMGroupManagementInteractor.h"
#import "GVUserDefaults.h"
#import "CMUserSessionController.h"
#import "GVUserDefaults+CammentSDKConfig.h"
#import "CMSDKNotificationPresenterPresenterInput.h"
#import "AWSCognito.h"
#import "CMCognitoFacebookAuthProvider.h"
#import "CMSDKNotificationPresenterWireframe.h"
#import "CMServerMessageController.h"
#import "CMOpenURLHelper.h"
#import "CMInvitation.h"
#import "CMErrorWireframe.h"
#import "DateTools.h"
#import "CMVideoSyncInteractor.h"
#import "CMUserBuilder.h"
#import "CMUserContants.h"
#import "NSArray+RacSequence.h"

@interface CMSDKService () <CMGroupManagementInteractorOutput>

@end

@implementation CMSDKService

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
#endif

        [[CMAnalytics instance] configureAWSMobileAnalytics];

        self.notificationPresenter = [CMSDKNotificationPresenterWireframe defaultPresenter];

        self.onSignedInOperationsQueue = [[NSOperationQueue alloc] init];
        self.onSignedInOperationsQueue.maxConcurrentOperationCount = 1;
        [self.onSignedInOperationsQueue setSuspended:YES];

        self.onSDKHasBeenConfiguredQueue = [[NSOperationQueue alloc] init];
        self.onSDKHasBeenConfiguredQueue.maxConcurrentOperationCount = 1;
        [self.onSDKHasBeenConfiguredQueue setSuspended:YES];

        [CMStore instance].connectionAvailable = YES;
        self.connectionReachibility = [CMConnectionReachability reachabilityForInternetConnection];
        [self.connectionReachibility startNotifier];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(identityIdDidChange:)
                                                     name:AWSCognitoIdentityIdChangedNotification
                                                   object:nil];

        [self clearTmpDirectory];

        DDLogDeveloperInfo(@"SDK started");
    }

    return self;
}

- (void)setSdkDelegate:(id <CMCammentSDKDelegate>)sdkDelegate {
    _sdkDelegate = sdkDelegate;
    self.serverMessageController.sdkDelegate = sdkDelegate;
}

- (void)setSdkUIDelegate:(id <CMCammentSDKUIDelegate>)sdkUIDelegate {
    _sdkUIDelegate = sdkUIDelegate;
    self.notificationPresenter.output = _sdkUIDelegate;
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
                                                           authChangedEventSubject:[CMStore instance].authentificationStatusSubject
                                                                         appConfig:[CMAppConfig instance]];

    if ([GVUserDefaults standardUserDefaults].isFirstSDKLaunch) {
        [self.userSessionController endSession];
        [GVUserDefaults standardUserDefaults].isFirstSDKLaunch = NO;
    }

    [self.onSDKHasBeenConfiguredQueue addOperationWithBlock:^{
        [self.awsServicesFactory configureAWSServices:self.awsServicesFactory.cognitoCredentialsProvider];
        [self configureIoTListenerWithNewIdentity:self.awsServicesFactory.cognitoCredentialsProvider.identityId];
        [CMStore instance].awsServicesConfigured = YES;
        DDLogDeveloperInfo(@"all services are up and running");
        [self checkIfDeferredDeepLinkExists];
    }];
}

- (void)wakeUpUserSession {
    [[self.userSessionController refreshSession:NO]
            continueWithBlock:^id(AWSTask<CMAuthStatusChangedEventContext *> *task) {
                if (task.error || task.result.state == CMCammentUserNotAuthentificated) {
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
    NSString *newIdentity = userInfo[AWSCognitoNotificationNewId];
    NSString *oldIdentity = userInfo[AWSCognitoNotificationPreviousId];

    [self identityHasChangedOldIdentity:oldIdentity newIdentity:newIdentity];
}

- (void)identityHasChangedOldIdentity:(NSString *)oldIdentity newIdentity:(NSString *)newIdentity {
    if (newIdentity == nil) {return;}

    [[[CMStore instance].authentificationStatusSubject filter:^BOOL(CMAuthStatusChangedEventContext * _Nullable status) {
        return [status.user.cognitoUserId isEqualToString:newIdentity];
    }] subscribeNext:^(CMAuthStatusChangedEventContext * _Nullable status) {
        [[CMStore instance] updateUserDataOnIdentityChangeOldIdentity:oldIdentity newIdentity:newIdentity];
    }];
    
    [[CMAnalytics instance] setMixpanelID:newIdentity];

    if (_awsServicesFactory.cognitoHasBeenConfigured) {
        [[self syncCognitoProfiles:oldIdentity newIdentity:newIdentity] continueWithBlock:^id(AWSTask<id> *t) {
            if (oldIdentity) {
                [[CMStore instance] updateUserDataOnIdentityChangeOldIdentity:oldIdentity newIdentity:newIdentity];
            }
            return nil;
        }];
        [self configureIoTListenerWithNewIdentity:newIdentity];
    }
}

- (AWSTask *)syncCognitoProfiles:(NSString *)oldIdentity newIdentity:(NSString *)newIdentity {

    if (!oldIdentity || !newIdentity || [oldIdentity isEqualToString:newIdentity]) {
        return nil;
    }

    AWSCognito *cognito = [AWSCognito CognitoForKey:CMCognitoName];

    AWSCognitoDataset *dataset = [cognito openOrCreateDataset:@"identitySet"];
    [dataset setConflictHandler:^AWSCognitoResolvedConflict *(NSString *datasetName, AWSCognitoConflict *conflict) {
        return [conflict resolveWithLocalRecord];
    }];

    return [[[[dataset synchronize] continueWithBlock:^id(AWSTask<id> *t) {
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

- (void)loadAssets {
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

    if (connectionAvailable && connectionAvailable != [CMStore instance].connectionAvailable) {

        if (self.userSessionController.userAuthentificationState == CMCammentUserNotAuthentificated) {
            DDLogDeveloperInfo(@"Reachability changed, updating user session..");
            [self wakeUpUserSession];
        }
        
        [[CMStore instance].fetchUpdatesSubject sendNext:@YES];
    }

    [CMStore instance].connectionAvailable = connectionAvailable;
}

- (void)dealloc {
    [self.connectionReachibility stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureIoTListenerWithNewIdentity:(NSString *)newIdentity {

    if (!self.serverListener) {
        self.serverMessageController = [[CMServerMessageController alloc]
                initWithSdkDelegate:self.sdkDelegate
              notificationPresenter:self.notificationPresenter
                              store:[CMStore instance]
          groupManagementInteractor:[[CMGroupManagementInteractor alloc] initWithOutput:nil
                                                                                  store:[CMStore instance]]];

        CMServerListenerCredentials *credentials = [CMServerListenerCredentials defaultCredentials];
        self.serverListener = [[CMServerListener alloc] initWithCredentials:credentials
                                                          messageController:self.serverMessageController
                                                                dataManager:self.awsServicesFactory.IoTDataManager];
    }

    [self.serverListener resubscribeToNewIdentity:newIdentity];
}

- (void)presentOpenURLSuggestion:(NSURL *)url {
    [self.notificationPresenter presentInvitationToChatByLinkInClipboard:url
                                                                  onJoin:^{
                                                                      [[CMOpenURLHelper new] openURL:url];
                                                                  }];
}

- (void)presentChatInvitation:(CMInvitation *)invitation onJoin:(void (^)())onJoin {

    __weak typeof(self) __weakSelf = self;
    [self.notificationPresenter presentInvitationToChat:invitation
                                                 onJoin:^{
                                                     CMShowMetadata *metadata = [CMShowMetadata new];;
                                                     metadata.uuid = invitation.showUuid;
                                                     typeof(__weakSelf) __strongSelf = __weakSelf;
                                                     if (!__strongSelf) {return;}

                                                     if (__strongSelf.sdkDelegate && [__strongSelf.sdkDelegate respondsToSelector:@selector(didOpenInvitationToShow:)]) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [__strongSelf.sdkDelegate didOpenInvitationToShow:metadata];
                                                         });
                                                     }

                                                     [[__strongSelf acceptInvitation:invitation] continueWithBlock:^id(AWSTask<id> *t) {
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             if (t.error) {
                                                                 [__weakSelf.notificationPresenter showToastMessage:CMLocalized(@"You are not allowed to join this group")];
                                                             } else {
                                                                 onJoin();
                                                             }
                                                         });
                                                         return nil;
                                                     }];
                                                 }];
}

- (void)presentLoginSuggestion:(NSString *)reason {
    [self.notificationPresenter presentLoginAlert:reason
                                          onLogin:^{
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [[self.userSessionController refreshSession:YES] continueWithBlock:^id(AWSTask<CMAuthStatusChangedEventContext *> *task) {
                                                      if (task.error || task.result.state != CMCammentUserAuthentificatedAsKnownUser) {
                                                          [self.onSignedInOperationsQueue cancelAllOperations];
                                                      } else {
                                                          [self.onSignedInOperationsQueue setSuspended:NO];
                                                      }
                                                      return nil;
                                                  }];
                                              });
                                          }
                                         onCancel:^{
                                             [self.onSignedInOperationsQueue cancelAllOperations];
                                         }];
}

- (AWSTask *)acceptInvitation:(CMInvitation *)invitation {
    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    CMAPIShowUuid *showUuid = [CMAPIShowUuid new];
    showUuid.showUuid = invitation.showUuid;
    return [client usergroupsGroupUuidUsersPost:invitation.userGroupUuid body:showUuid];
}

- (void)refreshUserIdentity:(BOOL)forceSignIn {
    [[self.userSessionController refreshSession:forceSignIn]
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

    [[CMVideoSyncInteractor new] requestNewShowTimestampIfNeeded:[CMStore instance].activeGroup.uuid];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DDLogInfo(@"didFinishLaunchingWithOptions hook has been installed");

#ifdef DEBUG
    [AWSDDLog sharedInstance].logLevel = AWSLogLevelDebug;
    [DDLog addLogger:[AWSDDTTYLogger sharedInstance]];
#endif

    [[CMAnalytics instance] configureMixpanelAnalytics];
    [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventAppStart];

    if (@available(iOS 9.0, *)) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionMixWithOthers error:nil];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    return YES;
}

- (void)checkIfDeferredDeepLinkExists {
    GVUserDefaults *userDefaults = [GVUserDefaults standardUserDefaults];
    if (userDefaults.isInstallationDeeplinkChecked) { return; }
    userDefaults.isInstallationDeeplinkChecked = YES;

    NSString *systemVersion = [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    NSString *deeplinkHash = [NSString stringWithFormat:@"iOS|%@", systemVersion];
    [[[CMAPIDevcammentClient defaultAPIClient] deferredDeeplinkGet:deeplinkHash
                                                                os:@"ios"]
            continueWithBlock:^id(AWSTask<id> *task) {
                if ([task.result isKindOfClass:[CMAPIDeeplink class]]) {
                    CMAPIDeeplink *deeplink = task.result;
                    DDLogInfo(@"def link %@", task.result);
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
    if (!invitation || !invitation.userGroupUuid) { return; }

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

        __weak typeof(self) weakSelf = self;

        NSString *groupUuid = invitation.userGroupUuid;
        AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidGet:groupUuid];

        if (task) {
            [task continueWithBlock:^id(AWSTask<id> *t) {
                if (!t.error && [t.result isKindOfClass:[CMAPIUsergroup class]]) {
                    CMAPIUsergroup *usergroup = t.result;

                    CMUsersGroup *group = [[[[[[[[CMUsersGroupBuilder new]
                            withUuid:invitation.userGroupUuid]
                            withShowUuid:usergroup.showId ?: invitation.showUuid]
                            withUsers:[usergroup.users map:^id(CMAPIUserinfo * userinfo) {
                                return [[[[[[[CMUserBuilder user]
                                        withCognitoUserId:userinfo.userCognitoIdentityId]
                                        withUsername:userinfo.name]
                                        withUserPhoto:userinfo.picture]
                                        withBlockStatus:userinfo.state]
                                        withOnlineStatus:userinfo.isOnline.boolValue ? CMUserOnlineStatus.Online : CMUserOnlineStatus.Offline]
                                        build];
                            }]]
                            withOwnerCognitoUserId:usergroup.userCognitoIdentityId]
                            withTimestamp:usergroup.timestamp]
                            withHostCognitoUserId:usergroup.hostId]
                            build];
                    CMShow *show = [[CMShow alloc] initWithUuid:invitation.showUuid
                                                            url:nil
                                                      thumbnail:nil
                                                       showType:[CMShowType videoWithShow:nil]
                                                       startsAt:nil];

                    CMUserJoinedMessage *userJoinedMessage = [[CMUserJoinedMessage alloc]
                            initWithUsersGroup:group
                                    joinedUser:self.userSessionController.user
                                          show:show];

                    if ([usergroup.userCognitoIdentityId isEqualToString:self.userSessionController.user.cognitoUserId]) {
                        CMShowMetadata *metadata = [CMShowMetadata new];;
                        metadata.uuid = invitation.showUuid;

                        if (weakSelf.sdkDelegate && [weakSelf.sdkDelegate respondsToSelector:@selector(didOpenInvitationToShow:)]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf.sdkDelegate didOpenInvitationToShow:metadata];
                                
                            });
                        }

                        [weakSelf.serverMessageController handleServerMessage:[CMServerMessage userJoinedWithUserJoinedMessage:userJoinedMessage]];
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf presentChatInvitation:invitation onJoin:^{
                                [weakSelf.serverMessageController handleServerMessage:[CMServerMessage userJoinedWithUserJoinedMessage:userJoinedMessage]];
                            }];
                        });
                    }
                } else {
                    NSDictionary* userInfo = t.error.userInfo[@"HTTPBody"];
                    NSNumber *statusCode = userInfo[@"statusCode"];
                    if (statusCode && statusCode.integerValue == 403) {
                        [weakSelf.notificationPresenter presentMeBlockedInGroupDialog];
                    } else {
                        CMErrorWireframe* errorWireframe = [CMErrorWireframe new];
                        UIViewController *viewController = [errorWireframe viewControllerDisplayingError:t.error];
                        if (!viewController) {
                            [errorWireframe presentErrorViewWithError:t.error
                                                     inViewController:nil];
                        } else {
                            [self.sdkUIDelegate cammentSDKWantsPresentViewController:viewController];
                        }
                    }
                }
                return nil;
            }];
        } else {
            NSError *error = [NSError errorWithDomain:@"tv.camment.ios"
                                                 code:0
                                             userInfo:@{
                                                NSLocalizedFailureReasonErrorKey: @"Could not join to the group. Check your internet connection and try again later."
                                             }];
            CMErrorWireframe* errorWireframe = [CMErrorWireframe new];
            UIViewController *viewController = [errorWireframe viewControllerDisplayingError:error];
            if (!viewController) {
                [errorWireframe presentErrorViewWithError:error
                                         inViewController:nil];
            } else {
                [self.sdkUIDelegate cammentSDKWantsPresentViewController:viewController];
            }
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
    DDLogInfo(@"Cleaned up %lu cache files", (unsigned long)tmpDirectory.count);
    for (NSString *file in tmpDirectory) {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:&error];
        if (error) {
            DDLogError(@"error on cleaning up cache %@", error);
        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self verifyURL:url];
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)application annotation:(id)annotation {
    return [self verifyURL:url];
}

- (void)leaveCurrentChatGroup {
    [[CMStore instance] cleanUpCurrentChatGroup];
}

- (void)updateVideoStreamStateIsPlaying:(BOOL)isPlaying show:(CMShowMetadata *)show timestamp:(NSTimeInterval)timestamp {
    [[CMVideoSyncInteractor new] updateVideoStreamStateIsPlaying:isPlaying
                                                            show:show
                                                       timestamp:timestamp];
}

@end
