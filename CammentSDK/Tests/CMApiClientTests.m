//
//  cammentTests.m
//  cammentTests
//
//  Created by Alexander Fedosov on 13.11.2017.
//  Copyright © 2017 Sportacam. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "CMAPIDevcammentClient.h"
#import "CMCammentViewInteractor.h"

SpecBegin(CMAPIDevcammentClientTests)

    CMAPIDevcammentClient *cmapiDevcammentClient = OCMClassMock([CMAPIDevcammentClient class]);

    describe(@"Api client", ^{

        it(@"should works", ^{

            CMUsersGroup *createdUserGroup = [[CMUsersGroup alloc] initWithUuid:@"testUUID"
                                                             ownerCognitoUserId:@"testOwner"
                                                                      timestamp:[@([NSDate new].timeIntervalSince1970) stringValue]
                                                                 invitationLink:nil];
            AWSTask *result = [AWSTask taskWithResult:createdUserGroup];
            OCMStub([cmapiDevcammentClient usergroupsPost]).andReturn(result);

            CMCammentViewInteractor* cammentViewInteractor = [[CMCammentViewInteractor alloc] initWithAPIClient:cmapiDevcammentClient];
            id outputMock = OCMStrictProtocolMock(@protocol(CMCammentViewInteractorOutput));
            cammentViewInteractor.output = outputMock;
            [cammentViewInteractor uploadCamment:nil];
            OCMExpect([outputMock interactorFailedToUploadCamment:[OCMArg any] error:[OCMArg any]]);
            OCMVerifyAllWithDelay(outputMock, 10);
        });
        
    });

SpecEnd


