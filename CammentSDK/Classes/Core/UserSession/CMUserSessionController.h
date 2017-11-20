//
// Created by Alexander Fedosov on 19.11.2017.
//

#import <Foundation/Foundation.h>
#import "CMUser.h"
#import "CMAuthStatusChangedEventContext.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentUserAuthentificationState.h"

@class AWSCognitoCredentialsProvider;
@class CMCognitoFacebookAuthProvider;
@protocol CMIdentityProvider;
@protocol CMAuthInteractorInput;
@class AWSTask;

@interface CMUserSessionController : NSObject

@property (nonatomic, strong) CMUser *user;

@property (nonatomic, assign) CMCammentUserAuthentificationState userAuthentificationState;

@property (nonatomic, strong, readonly) NSDictionary<NSString *, id> *tokens;

@property (nonatomic, strong, readonly) AWSCognitoCredentialsProvider *cognitoCredentialsProvider;

@property (nonatomic, strong, readonly) CMCognitoFacebookAuthProvider *cognitoFacebookIdentityProvider;

@property (nonatomic, readonly) id<CMAuthInteractorInput> authentificationInteractor;

@property (nonatomic, strong, readonly) RACSubject<CMAuthStatusChangedEventContext *> *authChangedEventSubject;

- (instancetype)initWithUser:(CMUser *)user
                      tokens:(NSDictionary<NSString *, id> *)tokens
  cognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCredentialsProvider
  authentificationInteractor:(id <CMAuthInteractorInput>)authentificationInteractor
cognitoFacebookIdentityProvider:(CMCognitoFacebookAuthProvider *)cognitoFacebookIdentityProvider
     authChangedEventSubject:(RACSubject<CMAuthStatusChangedEventContext *> *)authChangedEventSubject;

+ (CMUserSessionController *)instance;

+ (CMUserSessionController *)registerInstanceWithUser:(CMUser *)user
                                               tokens:(NSDictionary<NSString *, id> *)tokens
                           cognitoCredentialsProvider:(AWSCognitoCredentialsProvider *)cognitoCredentialsProvider
                           authentificationInteractor:(id <CMAuthInteractorInput>)authentificationInteractor
                      cognitoFacebookIdentityProvider:(CMCognitoFacebookAuthProvider *)cognitoFacebookIdentityProvider
                              authChangedEventSubject:(RACSubject<CMAuthStatusChangedEventContext *> *)authChangedEventSubject;

- (AWSTask *)refreshSession:(BOOL)forceSignIn;
- (void)endSession;

@end
