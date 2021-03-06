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
#import <CammentSDK/CMAPIDevcammentClient.h>
#import <CammentSDK/CMAPIDevcammentClient+defaultApiClient.h>
#import "CMAPIDevcammentClient+OCMock.h"
#import <CammentSDK/CMSDKService.h>
#import "CMTestAppConfig.h"
#import <FBSDKCoreKit/FBSDKTestUsersManager.h>
#import <FBSDKCoreKit/FBSDKAccessToken.h>
#import <FBSDKCoreKit/FBSDKSettings.h>
#import "CMTestFacebookIdentityProvider.h"
#import <CammentSDK/CMAWSServicesFactory.h>
#import <CammentSDK/CMConnectionReachability.h>
#import <CammentSDK/CMUserSessionController.h>
#import <CammentSDK/CMServerListener.h>
#import <CammentSDK/CMServerMessageController.h>
#import <CammentSDK/CMSDKNotificationPresenter.h>
#import "CMCammentSDKMockDelegate.h"
#import <CammentSDK/CMStore.h>
#import <CammentSDK/CMUsersGroupBuilder.h>

SpecBegin(CMAppServiceInvitationFlowTests)

__block CMSDKService *sdkService;
__block FBSDKTestUsersManager *fbsdkTestUsersManager;
__block CMTestFacebookIdentityProvider *facebookIdentityProvider;
__block CMTestAppConfig *appConfig;

describe(@"InvitationFlow", ^{
    
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
    
    it(@"should call delegates when open an invitation link, SDK is configured and user signed in", ^{
        
        waitUntil(^(DoneCallback done) {
            [sdkService configureWithApiKey:appConfig.apiKey
                           identityProvider:facebookIdentityProvider];
            [[sdkService onSDKHasBeenConfiguredQueue] addOperationWithBlock:^{
                done();
            }];
            
            [sdkService wakeUpUserSession];
        });
        
        // update mock on API client
        CMAPIDevcammentClient *client = [CMAPIDevcammentClient testableInstance];
        
        CMAPIUsergroup *cmapiUsergroup = [CMAPIUsergroup new];
        cmapiUsergroup.uuid = @"groupUUID";
        cmapiUsergroup.userCognitoIdentityId = sdkService.userSessionController.user.cognitoUserId;
        cmapiUsergroup.timestamp = [@([NSDate new].timeIntervalSince1970) stringValue];
        
        AWSTask *getGroupInfoResult = [AWSTask taskWithResult:cmapiUsergroup];
        OCMStub([client usergroupsGroupUuidGet:@"groupUUID"]).andReturn(getGroupInfoResult);
        [CMAPIDevcammentClient updateTestableInstance:client];
        
        // stub delegate's methods
        id delegate = OCMPartialMock([CMCammentSDKMockDelegate new]);
        sdkService.sdkDelegate = delegate;

        NSString *invitationURLString = @"camment://group/groupUUID/show/groupUUID";
        NSURL *deeplinkURL = [[NSURL alloc] initWithString:invitationURLString];
        
        OCMExpect([sdkService verifyInvitation:OCMOCK_ANY]).andForwardToRealObject;
        OCMExpect([delegate didOpenInvitationToShow:[OCMArg checkWithBlock:^BOOL(CMShowMetadata *obj) {
            expect(obj).toNot.beNil();
            expect(obj).to.beKindOf([CMShowMetadata class]);
            expect(obj.uuid).to.equal(@"groupUUID");
            return YES;
        }]]);
        OCMExpect([delegate didJoinToShow:[OCMArg checkWithBlock:^BOOL(CMShowMetadata *obj) {
            expect(obj).toNot.beNil();
            expect(obj).to.beKindOf([CMShowMetadata class]);
            expect(obj.uuid).to.equal(@"groupUUID");
            return YES;
        }]]);
        
        [sdkService application:[UIApplication sharedApplication]
                        openURL:deeplinkURL
                        options:nil];

        OCMVerifyAllWithDelay((id)sdkService, 30);
        OCMVerifyAllWithDelay(delegate, 30);
    });
    
    it(@"should call delegates when open an invitation link, SDK is configured and user signed in and joined to the same group already", ^{
        
        waitUntil(^(DoneCallback done) {
            [sdkService configureWithApiKey:appConfig.apiKey
                           identityProvider:facebookIdentityProvider];
            [[sdkService onSDKHasBeenConfiguredQueue] addOperationWithBlock:^{
                done();
            }];
            
            [sdkService wakeUpUserSession];
        });
        
        // update mock on API client
        CMAPIDevcammentClient *client = [CMAPIDevcammentClient testableInstance];
        
        CMAPIUsergroup *cmapiUsergroup = [CMAPIUsergroup new];
        cmapiUsergroup.uuid = @"groupUUID";
        cmapiUsergroup.userCognitoIdentityId = sdkService.userSessionController.user.cognitoUserId;
        cmapiUsergroup.timestamp = [@([NSDate new].timeIntervalSince1970) stringValue];
        
        AWSTask *getGroupInfoResult = [AWSTask taskWithResult:cmapiUsergroup];
        OCMStub([client usergroupsGroupUuidGet:OCMOCK_ANY]).andReturn(getGroupInfoResult);
        [CMAPIDevcammentClient updateTestableInstance:client];
        
        // stub delegate's methods
        id delegate = OCMPartialMock([CMCammentSDKMockDelegate new]);
        sdkService.sdkDelegate = delegate;
        
        NSString *invitationURLString = @"camment://group/groupUUID/show/groupUUID";
        NSURL *deeplinkURL = [[NSURL alloc] initWithString:invitationURLString];
        
        OCMExpect([sdkService verifyInvitation:OCMOCK_ANY]).andForwardToRealObject;
        OCMExpect([delegate didOpenInvitationToShow:[OCMArg checkWithBlock:^BOOL(CMShowMetadata *obj) {
            expect(obj).toNot.beNil();
            expect(obj).to.beKindOf([CMShowMetadata class]);
            expect(obj.uuid).to.equal(@"groupUUID");
            return YES;
        }]]);
        OCMExpect([delegate didJoinToShow:[OCMArg checkWithBlock:^BOOL(CMShowMetadata *obj) {
            expect(obj).toNot.beNil();
            expect(obj).to.beKindOf([CMShowMetadata class]);
            expect(obj.uuid).to.equal(@"groupUUID");
            return YES;
        }]]);
        
        CMUsersGroup *group = [[[[[[CMUsersGroupBuilder new] withUuid:cmapiUsergroup.uuid]
                withOwnerCognitoUserId:cmapiUsergroup.userCognitoIdentityId]
                withTimestamp:cmapiUsergroup.timestamp]
                withInvitationLink:invitationURLString]
                build];
        
        [CMStore instance].activeGroup = group;
        
        [sdkService application:[UIApplication sharedApplication]
                        openURL:deeplinkURL
                        options:nil];
        
        OCMVerifyAllWithDelay((id)sdkService, 30);
        OCMVerifyAllWithDelay(delegate, 30);
    });
    
    
    it(@"should call delegates when open an invitation link, SDK is NOT configured and user is signed in", ^{
        
        // update mock on API client
        CMAPIDevcammentClient *client = [CMAPIDevcammentClient testableInstance];
        
        __block CMAPIUsergroup *cmapiUsergroup = [CMAPIUsergroup new];
        cmapiUsergroup.uuid = @"groupUUID";
        cmapiUsergroup.timestamp = [@([NSDate new].timeIntervalSince1970) stringValue];
        
        AWSTask *getGroupInfoResult = [AWSTask taskWithResult:cmapiUsergroup];
        OCMStub([client usergroupsGroupUuidGet:OCMOCK_ANY]).andReturn(getGroupInfoResult);
        [CMAPIDevcammentClient updateTestableInstance:client];
        
        // stub delegate's methods
        id delegate = OCMPartialMock([CMCammentSDKMockDelegate new]);
        sdkService.sdkDelegate = delegate;
        
        NSString *invitationURLString = @"camment://group/groupUUID/show/groupUUID";
        NSURL *deeplinkURL = [[NSURL alloc] initWithString:invitationURLString];
        
        OCMExpect([sdkService verifyInvitation:OCMOCK_ANY]).andForwardToRealObject;
        OCMExpect([delegate didOpenInvitationToShow:[OCMArg checkWithBlock:^BOOL(CMShowMetadata *obj) {
            expect(obj).toNot.beNil();
            expect(obj).to.beKindOf([CMShowMetadata class]);
            expect(obj.uuid).to.equal(@"groupUUID");
            return YES;
        }]]);
        OCMExpect([delegate didJoinToShow:[OCMArg checkWithBlock:^BOOL(CMShowMetadata *obj) {
            expect(obj).toNot.beNil();
            expect(obj).to.beKindOf([CMShowMetadata class]);
            expect(obj.uuid).to.equal(@"groupUUID");
            return YES;
        }]]);
        
        [sdkService configureWithApiKey:appConfig.apiKey
                       identityProvider:facebookIdentityProvider];
        
        [[CMStore instance].authentificationStatusSubject subscribeNext:^(CMAuthStatusChangedEventContext * _Nullable x) {
            cmapiUsergroup.userCognitoIdentityId = x.user.cognitoUserId;
        }];
        
        [sdkService wakeUpUserSession];
        [sdkService application:[UIApplication sharedApplication]
                        openURL:deeplinkURL
                        options:nil];
        
        OCMVerifyAllWithDelay((id)sdkService, 30);
        OCMVerifyAllWithDelay(delegate, 30);
    });
});

SpecEnd

