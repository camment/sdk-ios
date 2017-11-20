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

static CMUserSessionController *_instance = nil;

@implementation CMUserSessionController

+ (CMUserSessionController *)instance {
    return _instance;
}

+ (CMUserSessionController *)registerInstanceWithUser:(CMUser *)user tokens:(NSDictionary<NSString *, id> *)tokens cognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCredentialsProvider authentificationInteractor:(id <CMAuthInteractorInput>)authentificationInteractor cognitoFacebookIdentityProvider:(CMCognitoFacebookAuthProvider *)cognitoFacebookIdentityProvider authChangedEventSubject:(RACSubject<CMAuthStatusChangedEventContext *> *)authChangedEventSubject {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] initWithUser:user tokens:tokens cognitoCredentialsProvider:cognitoCredentialsProvider authentificationInteractor:authentificationInteractor cognitoFacebookIdentityProvider:cognitoFacebookIdentityProvider authChangedEventSubject:authChangedEventSubject];
        }
    }

    return _instance;
}

- (instancetype)initWithUser:(CMUser *)user tokens:(NSDictionary<NSString *, id> *)tokens cognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCredentialsProvider authentificationInteractor:(id <CMAuthInteractorInput>)authentificationInteractor cognitoFacebookIdentityProvider:(CMCognitoFacebookAuthProvider *)cognitoFacebookIdentityProvider authChangedEventSubject:(RACSubject<CMAuthStatusChangedEventContext *> *)authChangedEventSubject {
    self = [super init];
    if (self) {
        self.user = user;
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

- (void)updateUserProfileData:(NSDictionary *)profileData {
    CMUser *updatedUser = [[[[[[CMUserBuilder userFromExistingUser:self.user]
            withUsername:profileData[CMCammentIdentityUsername]]
            withFbUserId:profileData[CMCammentIdentityUUID]]
            withUserPhoto:profileData[CMCammentIdentityProfilePicture]]
            withEmail:profileData[CMCammentIdentityEmail]]
            build];
    self.user = updatedUser;
}

- (AWSTask *)refreshCognitoSession {
    [_cognitoCredentialsProvider clearCredentials];
    return [[_cognitoCredentialsProvider credentials]
            continueWithSuccessBlock:^id(AWSTask<id> *t) {
                return [_cognitoCredentialsProvider getIdentityId];
            }];
}

- (AWSTask *)refreshSession:(BOOL)forceSignIn {
    return [[[_authentificationInteractor refreshIdentity:forceSignIn]
            continueWithSuccessBlock:^id(AWSTask<id> *task) {
                [self updateUserProfileData:task.result];
                _cognitoFacebookIdentityProvider.facebookAccessToken = task.result[CMCammentIdentityProviderFacebook];
                return [self refreshCognitoSession];
            }]
            continueWithSuccessBlock:^id(AWSTask<id> *t) {
                if (_cognitoFacebookIdentityProvider.facebookAccessToken) {
                    self.userAuthentificationState = CMCammentUserAuthentificatedAsKnownUser;
                } else {
                    self.userAuthentificationState = CMCammentUserAuthentificatedAnonymous;
                }

                self.user = [[[CMUserBuilder userFromExistingUser:self.user] withCognitoUserId:t.result] build];

                [self notifyAboutAuthStatusChanged];

                return [AWSTask taskWithResult:self.user];
            }];
}

- (void)endSession {
    self.userAuthentificationState = CMCammentUserNotAuthentificated;
    self.user = nil;
    [self.authentificationInteractor logOut];
    [self.cognitoCredentialsProvider clearKeychain];
    [self notifyAboutAuthStatusChanged];
}

- (void)notifyAboutAuthStatusChanged{
    CMAuthStatusChangedEventContext *context = [[CMAuthStatusChangedEventContext alloc] initWithState:self.userAuthentificationState
                                                                                                 user:self.user];
    [self.authChangedEventSubject sendNext:context];
}

@end
