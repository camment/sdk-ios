//
//  CMAPIDevcammentClient+OCMock.m
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 14.11.2017.
//

#import "CMAPIDevcammentClient+OCMock.h"

static CMAPIDevcammentClient *_instance = nil;

@implementation CMAPIDevcammentClient (OCMock)

+ (CMAPIDevcammentClient *)testableInstance {

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [CMAPIDevcammentClient mock_workingApiClient];
        }
    }

    return _instance;
}

+ (void)updateTestableInstance:(CMAPIDevcammentClient *)instance {

    @synchronized (self) {
        if (_instance == nil) {
            _instance = instance;
        }
    }
}

+ (CMAPIDevcammentClient *)mock_workingApiClient {
    CMAPIDevcammentClient *cmapiDevcammentClient = OCMClassMock([CMAPIDevcammentClient class]);

    CMAPIUsergroup *cmapiUsergroup = [CMAPIUsergroup new];
    cmapiUsergroup.uuid = @"groupUUID";
    cmapiUsergroup.userCognitoIdentityId = @"userUUID";
    cmapiUsergroup.timestamp = [@([NSDate new].timeIntervalSince1970) stringValue];

    CMAPICamment *cmapiCamment = [CMAPICamment new];
    cmapiCamment.uuid = @"cammentUUID";
    cmapiCamment.userCognitoIdentityId = @"userUUID";
    cmapiCamment.userGroupUuid = @"groupUUID";

    // Mock new group created successfully
    AWSTask *createdGroupResult = [AWSTask taskWithResult:cmapiUsergroup];
    OCMStub([cmapiDevcammentClient usergroupsPost:OCMOCK_ANY]).andReturn(createdGroupResult);

    // Mock camment posted successfully
    AWSTask *cammentPostedToGroup = [AWSTask taskWithResult:cmapiCamment];
    OCMStub([cmapiDevcammentClient usergroupsGroupUuidCammentsPost:OCMOCK_ANY body:OCMOCK_ANY])
            .andReturn(cammentPostedToGroup);

    CMAPIOpenIdToken *token = [CMAPIOpenIdToken new];
    token.identityId = @"TestUser";
    OCMStub([cmapiDevcammentClient usersGetOpenIdTokenGet:OCMOCK_ANY])
            .andReturn([AWSTask taskWithResult:token]);
    
    return cmapiDevcammentClient;
}

@end
