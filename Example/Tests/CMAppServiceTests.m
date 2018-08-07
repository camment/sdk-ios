//
//  CMAppServiceTests.m
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 22.11.2017.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <AWSS3/AWSS3.h>
#import <CammentSDK/CMSDKService.h>
#import <FBSDKCoreKit/FBSDKTestUsersManager.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKSettings.h>
#import "CMTestAppConfig.h"
#import "CMTestFacebookIdentityProvider.h"
#import <CammentSDK/CMAWSServicesFactory.h>
#import <CammentSDK/CMConnectionReachability.h>
#import <CammentSDK/CMUserSessionController.h>
#import <CammentSDK/CMServerListener.h>
#import <CammentSDK/CMServerMessageController.h>
#import <CammentSDK/CMSDKNotificationPresenter.h>

SpecBegin(CMSDKServiceTests)

    __block CMSDKService *sdkService;
    __block FBSDKTestUsersManager *fbsdkTestUsersManager;
    __block CMTestFacebookIdentityProvider *facebookIdentityProvider;
    __block CMTestAppConfig *appConfig;

    describe(@"CMSDKService", ^{
        
        beforeAll(^{
            appConfig = [CMTestAppConfig new];
            
            [FBSDKSettings setAppID:appConfig.facebookAppId];
            fbsdkTestUsersManager = [FBSDKTestUsersManager sharedInstanceForAppID:appConfig.facebookAppId
                                                                        appSecret:appConfig.facebookAppSecret];
            facebookIdentityProvider = [[CMTestFacebookIdentityProvider alloc] init];
            
            waitUntil(^(DoneCallback done) {
                [fbsdkTestUsersManager requestTestAccountTokensWithArraysOfPermissions:nil
                                                                      createIfNotFound:YES
                                                                     completionHandler:^(NSArray *tokens, NSError *error) {
                                                                         FBSDKAccessToken *token = tokens.firstObject;
                                                                         facebookIdentityProvider.facebookAccessToken = token.tokenString;
                                                                         done();
                                                                     }];
            });
        });
        
        beforeEach(^{
            sdkService = OCMPartialMock([CMSDKService new]);
        });
        
        afterEach(^{
            
        });
        
        it(@"should be instantiated properly", ^{
            [sdkService configureWithApiKey:appConfig.apiKey
                           identityProvider:facebookIdentityProvider];

            expect(sdkService).toNot.beNil();
            expect(sdkService).to.beKindOf([CMSDKService class]);

            expect(sdkService.awsServicesFactory).toNot.beNil();
            expect(sdkService.awsServicesFactory).to.beKindOf([CMAWSServicesFactory class]);

            expect(sdkService.onSignedInOperationsQueue).toNot.beNil();
            expect(sdkService.onSignedInOperationsQueue).to.beKindOf([NSOperationQueue class]);
            expect(sdkService.onSignedInOperationsQueue.maxConcurrentOperationCount).to.equal(1);
            expect(sdkService.onSignedInOperationsQueue.suspended).to.equal(YES);

            expect(sdkService.onSDKHasBeenConfiguredQueue).toNot.beNil();
            expect(sdkService.onSDKHasBeenConfiguredQueue).to.beKindOf([NSOperationQueue class]);
            expect(sdkService.onSDKHasBeenConfiguredQueue.maxConcurrentOperationCount).to.equal(1);
            expect(sdkService.onSDKHasBeenConfiguredQueue.suspended).to.equal(YES);

            expect(sdkService.connectionReachibility).toNot.beNil();
            expect(sdkService.connectionReachibility).to.beKindOf([CMConnectionReachability class]);

            expect(sdkService.fileLogger).toNot.beNil();
            expect(sdkService.fileLogger).to.beKindOf([DDFileLogger class]);

            expect(sdkService.userSessionController).toNot.beNil();
            expect(sdkService.userSessionController).to.beKindOf([CMUserSessionController class]);

            expect(sdkService.notificationPresenter).toNot.beNil();
            expect(sdkService.notificationPresenter).to.conformTo(@protocol(CMSDKNotificationPresenterPresenterInput));
        });

        it(@"should be configured", ^{
            waitUntil(^(DoneCallback done) {
                [sdkService configureWithApiKey:appConfig.apiKey
                               identityProvider:facebookIdentityProvider];
                [[sdkService onSDKHasBeenConfiguredQueue] addOperationWithBlock:^{
                    done();
                }];

                [sdkService wakeUpUserSession];
            });

            expect(sdkService.serverListener).toNot.beNil();
            expect(sdkService.serverListener).to.beKindOf([CMServerListener class]);

            expect(sdkService.serverMessageController).toNot.beNil();
            expect(sdkService.serverMessageController).to.beKindOf([CMServerMessageController class]);
        });

        it(@"should pass delegated properly", ^{
            
            waitUntil(^(DoneCallback done) {
                [sdkService configureWithApiKey:appConfig.apiKey
                               identityProvider:facebookIdentityProvider];
                [[sdkService onSDKHasBeenConfiguredQueue] addOperationWithBlock:^{
                    done();
                }];
                
                [sdkService wakeUpUserSession];
            });
            
            id delegate = [NSObject new];
            id uiDelegate = [NSObject new];

            sdkService.sdkDelegate = delegate;
            sdkService.sdkUIDelegate = uiDelegate;

            expect(sdkService.sdkDelegate).to.beIdenticalTo(delegate);
            expect(sdkService.sdkUIDelegate).to.beIdenticalTo(uiDelegate);
            expect(sdkService.notificationPresenter.output).to.beIdenticalTo(uiDelegate);
            expect(sdkService.serverMessageController.sdkDelegate).to.beIdenticalTo(delegate);
        });
    });

SpecEnd
