//
// Created by Alexander Fedosov on 19.11.2017.
//

#import "CMUserSessionController.h"
#import "AWSCredentialsProvider.h"
#import "CMIdentityProvider.h"
#import "CMUserBuilder.h"
#import "CMAuthInteractorInput.h"
#import "AWSTask.h"
#import "CMCognitoFacebookAuthProvider.h"
#import "RACSubject.h"
#import "CMAuthStatusChangedEventContext.h"
#import "CMAPIDevcammentClient.h"
#import "CMAppConfig.h"

static CMUserSessionController *_instance = nil;

@interface CMUserSessionController ()
@property(nonatomic, strong) CMAppConfig *appConfig;
@end

@implementation CMUserSessionController

+ (CMUserSessionController *)instance {
    return _instance;
}

+ (CMUserSessionController *)registerInstanceWithUser:(CMUser *)user tokens:(NSDictionary<NSString *, id> *)tokens cognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCredentialsProvider authentificationInteractor:(id <CMAuthInteractorInput>)authentificationInteractor cognitoFacebookIdentityProvider:(CMCognitoFacebookAuthProvider *)cognitoFacebookIdentityProvider authChangedEventSubject:(RACSubject<CMAuthStatusChangedEventContext *> *)authChangedEventSubject appConfig:(CMAppConfig *)appConfig {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initWithUser:user tokens:tokens cognitoCredentialsProvider:cognitoCredentialsProvider authentificationInteractor:authentificationInteractor cognitoFacebookIdentityProvider:cognitoFacebookIdentityProvider authChangedEventSubject:authChangedEventSubject appConfig:appConfig];
        }
    }

    return _instance;
}

- (instancetype)initWithUser:(CMUser *)user tokens:(NSDictionary<NSString *, id> *)tokens cognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCredentialsProvider authentificationInteractor:(id <CMAuthInteractorInput>)authentificationInteractor cognitoFacebookIdentityProvider:(CMCognitoFacebookAuthProvider *)cognitoFacebookIdentityProvider authChangedEventSubject:(RACSubject<CMAuthStatusChangedEventContext *> *)authChangedEventSubject appConfig:(CMAppConfig *)appConfig {
    self = [super init];
    if (self) {
        self.user = user;
        self.appConfig = appConfig;
        _tokens = tokens;
        _cognitoCredentialsProvider = cognitoCredentialsProvider;
        _authentificationInteractor = authentificationInteractor;
        _cognitoFacebookIdentityProvider = cognitoFacebookIdentityProvider;
        _userAuthentificationState = CMCammentUserNotAuthentificated;
        _authChangedEventSubject = authChangedEventSubject;
        [self notifyAboutAuthStatusChanged];
    }

    return self;
}

- (AWSTask *)refreshCognitoSession {
    [_cognitoCredentialsProvider clearCredentials];
    return [[_cognitoCredentialsProvider credentials]
            continueWithSuccessBlock:^id(AWSTask<id> *t) {
                return [_cognitoCredentialsProvider getIdentityId];
            }];
}

- (AWSTask *)updateUserProfileInfo {
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                         credentialsProvider:_cognitoCredentialsProvider];
    [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:@"UserSessionUpdater"];
    CMAPIDevcammentClient *client = [CMAPIDevcammentClient clientForKey:@"UserSessionUpdater"];
    [client setAPIKey:_appConfig.apiKey];
    AWSTask *getUserInfo = [client userinfoGet];
    return [getUserInfo continueWithSuccessBlock:^id(AWSTask<id> *t) {
        CMAPIUserinfo *userInfo = t.result;
        if (userInfo) {
            self.user = [[[[CMUserBuilder userFromExistingUser:self.user]
                    withUsername:userInfo.name]
                    withUserPhoto:userInfo.picture] build];
        }
        return nil;
    }];
}

- (AWSTask *)refreshSession:(BOOL)forceSignIn {
    return [[[[_authentificationInteractor refreshIdentity:forceSignIn]
            continueWithSuccessBlock:^id(AWSTask<id> *task) {
                _cognitoFacebookIdentityProvider.facebookAccessToken = task.result[CMCammentIdentityProviderFacebook];
                return [self refreshCognitoSession];
            }]
            continueWithSuccessBlock:^id(AWSTask<id> *t) {
                if (_cognitoFacebookIdentityProvider.facebookAccessToken) {
                    self.userAuthentificationState = CMCammentUserAuthentificatedAsKnownUser;
                } else {
                    self.userAuthentificationState = CMCammentUserAuthentificatedAnonymous;
                }

                _user = [[[CMUserBuilder userFromExistingUser:self.user] withCognitoUserId:t.result] build];

                return [self updateUserProfileInfo];
            }]
            continueWithSuccessBlock:^id(AWSTask<id> *t) {
                [self notifyAboutAuthStatusChanged];
                return [AWSTask taskWithResult:[self currentAuthenticationContext]];
            }];
}

- (void)endSession {
    self.userAuthentificationState = CMCammentUserNotAuthentificated;
    self.user = nil;
    [self.authentificationInteractor logOut];
    self.cognitoFacebookIdentityProvider.facebookAccessToken = nil;
    [self.cognitoCredentialsProvider clearKeychain];
    [self notifyAboutAuthStatusChanged];
}

- (CMAuthStatusChangedEventContext *)currentAuthenticationContext {
    CMAuthStatusChangedEventContext *context = [[CMAuthStatusChangedEventContext alloc] initWithState:self.userAuthentificationState
                                                                                                 user:self.user];
    return context;
}

- (void)notifyAboutAuthStatusChanged {
    [self.authChangedEventSubject sendNext:[self currentAuthenticationContext]];
}

@end
