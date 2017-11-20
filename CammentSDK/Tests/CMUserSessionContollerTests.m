//
//  CMUserSessionContollerTests
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 18.11.2017.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <AWSS3/AWSS3.h>
#import "CMCognitoFacebookAuthProvider.h"
#import "CMAppConfig.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CMStore.h"
#import "CMAPIDevcammentClient.h"
#import "CMUserSessionController.h"
#import "CMAuthInteractor.h"
#import "CMTestFacebookIdentityProvider.h"

static NSString *const facebookAppID = @"272405646569362";

static NSString *const facebookAppSecret = @"02cd77cb360ba35e5f9bdfa038f091ca";

static NSString *const apiKey = @"iYeooUSdMZ8FOBMZeL2zb9YDLdW0uvbVlitykh7d";

SpecBegin(CMUserSessionContollerTests)

    __block CMAPIDevcammentClient *APIClient;
    __block FBSDKTestUsersManager *fbsdkTestUsersManager;
    __block FBSDKAccessToken *testUserToken;
    __block CMCognitoFacebookAuthProvider *cognitoFacebookAuthProvider;
    __block AWSCognitoCredentialsProvider *credentialsProvider;
    __block CMUserSessionController *userSessionController;
    __block id <CMAuthInteractorInput> authInteractor;
    __block CMTestFacebookIdentityProvider *facebookIdentityProvider;
    __block RACReplaySubject<CMAuthStatusChangedEventContext *> *authChangedEventSubject;

    describe(@"CMUserSessionContollerTests", ^{

        beforeAll(^{
            [AWSDDLog sharedInstance].logLevel = AWSDDLogLevelVerbose;
            fbsdkTestUsersManager = [FBSDKTestUsersManager sharedInstanceForAppID:facebookAppID
                                                                        appSecret:facebookAppSecret];
            waitUntil(^(DoneCallback done) {
                [fbsdkTestUsersManager requestTestAccountTokensWithArraysOfPermissions:nil
                                                                      createIfNotFound:YES
                                                                     completionHandler:^(NSArray *tokens, NSError *error) {
                                                                         testUserToken = tokens.firstObject;
                                                                         done();
                                                                     }];
            });
        });

        beforeEach(^{
            authChangedEventSubject = [RACReplaySubject replaySubjectWithCapacity:1];

            AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                                 credentialsProvider:nil];
            [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:CMAnonymousAPIClientName];
            APIClient = OCMPartialMock([CMAPIDevcammentClient clientForKey:CMAnonymousAPIClientName]);
            [APIClient setAPIKey:apiKey];

            cognitoFacebookAuthProvider = OCMPartialMock([[CMCognitoFacebookAuthProvider alloc] initWithRegionType:AWSRegionEUCentral1
                                                                                                    identityPoolId:@"eu-central-1:aa96090c-0423-46d1-a584-20086c0e134d"
                                                                                                   useEnhancedFlow:YES
                                                                                           identityProviderManager:nil
                                                                                                         APIClient:APIClient]);
            credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                    initWithRegionType:AWSRegionEUCentral1
                      identityProvider:cognitoFacebookAuthProvider];

            facebookIdentityProvider = OCMPartialMock([CMTestFacebookIdentityProvider new]);
            authInteractor = [[CMAuthInteractor alloc] initWithIdentityProvider:facebookIdentityProvider];
            userSessionController = [[CMUserSessionController alloc] initWithUser:nil
                                                                           tokens:nil
                                                       cognitoCredentialsProvider:credentialsProvider
                                                       authentificationInteractor:authInteractor
                                                  cognitoFacebookIdentityProvider:cognitoFacebookAuthProvider authChangedEventSubject:authChangedEventSubject];
            [userSessionController endSession];
        });

        afterEach(^{
            [CMAPIDevcammentClient removeClientForKey:CMAnonymousAPIClientName];
            [CMAPIDevcammentClient removeClientForKey:CMAPIClientName];
        });

        afterAll(^{
            [credentialsProvider clearKeychain];
        });

        it(@"should be created", ^{
            expect(userSessionController).toNot.beNil();
            expect(userSessionController).to.beKindOf([CMUserSessionController class]);
        });

        it(@"should not have an identity", ^{
            expect(credentialsProvider.identityId).to.beNil();
            expect(userSessionController.userAuthentificationState).to.equal(CMCammentUserNotAuthentificated);
            expect(userSessionController.user).to.beNil();

            CMAuthStatusChangedEventContext *authContext = authChangedEventSubject.first;
            expect(authContext).toNot.beNil();
            expect(authContext.user).to.beNil();
            expect(authContext.state).to.equal(CMCammentUserNotAuthentificated);
        });

        it(@"should get an anonymous identity", ^{
            waitUntil(^(DoneCallback done) {
                [[userSessionController refreshSession:NO]
                        continueWithBlock:^id _Nullable(AWSTask *_Nonnull task) {

                            expect(task).toNot.beNil();
                            expect(task.result).to.beKindOf([CMUser class]);
                            expect(task.error).to.beNil();

                            CMAuthStatusChangedEventContext *authContext = authChangedEventSubject.first;
                            expect(authContext).toNot.beNil();
                            expect(authContext.user).to.beIdenticalTo(task.result);
                            expect(authContext.state).to.equal(CMCammentUserAuthentificatedAnonymous);

                            done();

                            return nil;
                        }];
            });
            OCMVerify([facebookIdentityProvider refreshUserIdentity:[OCMArg any] forceSignin:NO]);
            OCMVerify([cognitoFacebookAuthProvider logins]);
        });

        it(@"should get a facebook identity", ^{
            facebookIdentityProvider.facebookAccessToken = testUserToken.tokenString;

            __block NSString *cognitoIdentity;
            waitUntil(^(DoneCallback done) {
                [[userSessionController refreshSession:NO]
                        continueWithBlock:^id _Nullable(AWSTask<CMUser *> *_Nonnull task) {

                            expect(task).toNot.beNil();
                            expect(task.result).to.beKindOf([CMUser class]);
                            expect(task.error).to.beNil();

                            CMAuthStatusChangedEventContext *authContext = authChangedEventSubject.first;
                            expect(authContext).toNot.beNil();
                            expect(authContext.user).to.beIdenticalTo(task.result);
                            expect(authContext.state).to.equal(CMCammentUserAuthentificatedAsKnownUser);

                            cognitoIdentity = task.result.cognitoUserId;

                            done();

                            return nil;
                        }];
            });
            OCMVerify([cognitoFacebookAuthProvider logins]);
            OCMVerify([cognitoFacebookAuthProvider token]);
            NSString *facebookToken = facebookIdentityProvider.facebookAccessToken;
            OCMVerify([APIClient usersGetOpenIdTokenGet:facebookToken]);

            [userSessionController endSession];
            OCMVerify([facebookIdentityProvider logOut]);

            CMAuthStatusChangedEventContext *authContext = authChangedEventSubject.first;
            expect(authContext).toNot.beNil();
            expect(authContext.user).to.beNil();
            expect(authContext.state).to.equal(CMCammentUserNotAuthentificated);

            // logout, then login and compare identities
            waitUntil(^(DoneCallback done) {
                [[userSessionController refreshSession:NO]
                        continueWithBlock:^id _Nullable(AWSTask<CMUser *> *_Nonnull task) {

                            expect(task).toNot.beNil();
                            expect(task.result).to.beKindOf([CMUser class]);
                            expect(task.error).to.beNil();

                            CMAuthStatusChangedEventContext *authContext = authChangedEventSubject.first;
                            expect(authContext).toNot.beNil();
                            expect(authContext.user).to.beIdenticalTo(task.result);
                            expect(authContext.state).to.equal(CMCammentUserAuthentificatedAsKnownUser);

                            expect(cognitoIdentity).to.equal(authContext.user.cognitoUserId);
                            done();
                            return nil;
                        }];
            });

            cognitoIdentity = nil;
        });

    });

SpecEnd



