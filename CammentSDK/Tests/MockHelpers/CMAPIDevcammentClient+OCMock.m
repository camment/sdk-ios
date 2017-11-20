//
//  CMAPIDevcammentClient+OCMock.m
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 14.11.2017.
//

#import "CMAPIDevcammentClient+OCMock.h"

@implementation CMAPIDevcammentClient (OCMock)

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
    OCMStub([cmapiDevcammentClient usergroupsPost]).andReturn(createdGroupResult);

    // Mock camment posted successfully
    AWSTask *cammentPostedToGroup = [AWSTask taskWithResult:cmapiCamment];
    OCMStub([cmapiDevcammentClient usergroupsGroupUuidCammentsPost:OCMOCK_ANY body:OCMOCK_ANY])
            .andReturn(cammentPostedToGroup);

    return cmapiDevcammentClient;
}

@end
