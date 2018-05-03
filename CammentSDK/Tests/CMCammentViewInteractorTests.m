//
//  CMCammentViewInetractorTests.m
//  cammentTests
//
//  Created by Alexander Fedosov on 13.11.2017.
//  Copyright © 2017 Sportacam. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "CMCammentBuilder.h"
#import "CMAPIDevcammentClient.h"
#import "CMCammentViewInteractor.h"
#import "CMCammentUploader.h"
#import "CMAPIDevcammentClient+OCMock.h"
#import "CMCammentUploader+OCMock.h"

NSString *userCognitoUUID = @"userUUID";
NSString *usergroupUUID = @"groupUUID";
NSString *showUUID = @"groupUUID";
NSString *cammentUUID = @"cammentUUID";


SpecBegin(CMCammentViewInteractorTests)

    __block CMAPIDevcammentClient *cmapiDevcammentClient;
    __block CMCammentViewInteractor *cammentViewInteractor;
    __block id outputMock;
    __block CMCammentUploader *cammentUploader;

    CMAPIUsergroup *cmapiUsergroup = [CMAPIUsergroup new];
    cmapiUsergroup.uuid = usergroupUUID;
    cmapiUsergroup.userCognitoIdentityId = userCognitoUUID;
    cmapiUsergroup.timestamp = [@([NSDate new].timeIntervalSince1970) stringValue];

    CMCamment *cammentToUpload = [[CMCamment alloc] initWithShowUuid:showUUID
                                                       userGroupUuid:usergroupUUID
                                                                uuid:cammentUUID
                                                           remoteURL:nil
                                                            localURL:@"http://camment.tv"
                                                        thumbnailURL:nil
                                               userCognitoIdentityId:userCognitoUUID
                                                          localAsset:nil
                                                         isMadeByBot:NO
                                                             botUuid:nil
                                                           botAction:nil
                                                           isDeleted:NO
                                                     shouldBeDeleted:NO
                                                              status:[CMCammentStatus new]];

    describe(@"CammentViewInteractor", ^{

        beforeEach(^{
            cmapiDevcammentClient = [CMAPIDevcammentClient mock_workingApiClient];
            cammentUploader = [CMCammentUploader mock_workingCammentUploader];

            cammentViewInteractor = [[CMCammentViewInteractor alloc] initWithAPIClient:cmapiDevcammentClient
                                                                       cammentUploader:cammentUploader];

            outputMock = OCMStrictProtocolMock(@protocol(CMCammentViewInteractorOutput));
            cammentViewInteractor.output = outputMock;
        });

        it(@"should be created", ^{
            expect(cammentViewInteractor).toNot.beNil();
            expect(cammentViewInteractor).to.beKindOf([CMCammentViewInteractor class]);
        });

        it(@"should post camment in usergroup", ^{
            OCMExpect([cmapiDevcammentClient usergroupsGroupUuidCammentsPost:cammentToUpload.userGroupUuid
                                                                        body:[OCMArg checkWithBlock:^BOOL(CMAPICammentInRequest *obj) {
                                                                            expect(obj).toNot.beNil();
                                                                            expect(obj).to.beKindOf([CMAPICammentInRequest class]);
                                                                            expect(obj.uuid).to.equal(cammentToUpload.uuid);
                                                                            return YES;
                                                                        }]]);
            [cammentViewInteractor uploadCamment:cammentToUpload];
            OCMVerifyAllWithDelay(outputMock, 3);
        });

        it(@"should fail uploading nil camment", ^{
            OCMExpect([outputMock interactorFailedToUploadCamment:nil
                                                            error:[OCMArg checkWithBlock:^BOOL(NSError *error) {
                                                                expect(error.domain).to.equal(CMCammentViewInteractorErrorDomain);
                                                                expect(error.code).to.equal(CMCammentViewInteractorErrorMissingRequiredParameters);
                                                                return YES;
                                                            }]]);
            [cammentViewInteractor uploadCamment:nil];
            OCMVerifyAllWithDelay(outputMock, 3);
        });

        it(@"should fail uploading camment without uuid", ^{
            CMCamment *cammentWithoutUUID = [[[CMCammentBuilder new] withLocalURL:@"http://camment.tv"] build];
            OCMExpect([outputMock interactorFailedToUploadCamment:[OCMArg checkWithBlock:^BOOL(CMCamment *camment) {
                        expect(camment.localURL).to.equal(cammentWithoutUUID.localURL);
                        return YES;
                    }]
                                                            error:[OCMArg checkWithBlock:^BOOL(NSError *error) {
                                                                expect(error.domain).to.equal(CMCammentViewInteractorErrorDomain);
                                                                expect(error.code).to.equal(CMCammentViewInteractorErrorProvidedParametersAreIncorrect);
                                                                return YES;
                                                            }]]);
            [cammentViewInteractor uploadCamment:cammentWithoutUUID];
            OCMVerifyAllWithDelay(outputMock, 3);
        });

        it(@"should fail uploading camment without localURL", ^{
            CMCamment *cammentWithoutLocalAssetURL = [[[CMCammentBuilder new] withUuid:@"cammentUUID"] build];
            OCMExpect([outputMock interactorFailedToUploadCamment:[OCMArg checkWithBlock:^BOOL(CMCamment *camment) {
                        expect(camment.uuid).to.equal(cammentWithoutLocalAssetURL.uuid);
                        return YES;
                    }]
                                                            error:[OCMArg checkWithBlock:^BOOL(NSError *error) {
                                                                expect(error.domain).to.equal(CMCammentViewInteractorErrorDomain);
                                                                expect(error.code).to.equal(CMCammentViewInteractorErrorProvidedParametersAreIncorrect);
                                                                return YES;
                                                            }]]);
            [cammentViewInteractor uploadCamment:cammentWithoutLocalAssetURL];
            OCMVerifyAllWithDelay(outputMock, 3);
        });

        it(@"should fail uploading camment with incorrect localURL", ^{
            CMCamment *cammentWithIncorrectURL = [[[CMCammentBuilder new] withLocalURL:@"incorrect url"] build];
            OCMExpect([outputMock interactorFailedToUploadCamment:[OCMArg checkWithBlock:^BOOL(CMCamment *camment) {
                        expect(camment.localURL).to.equal(cammentWithIncorrectURL.localURL);
                        return YES;
                    }]
                                                            error:[OCMArg checkWithBlock:^BOOL(NSError *error) {
                                                                expect(error.domain).to.equal(CMCammentViewInteractorErrorDomain);
                                                                expect(error.code).to.equal(CMCammentViewInteractorErrorProvidedParametersAreIncorrect);
                                                                return YES;
                                                            }]]);
            [cammentViewInteractor uploadCamment:cammentWithIncorrectURL];
            OCMVerifyAllWithDelay(outputMock, 3);
        });

        it(@"should send camment successfully", ^{
            OCMExpect([cmapiDevcammentClient usergroupsGroupUuidCammentsPost:cammentToUpload.userGroupUuid
                                                                        body:[OCMArg checkWithBlock:^BOOL(CMAPICammentInRequest *obj) {
                                                                            expect(obj).toNot.beNil();
                                                                            expect(obj).to.beKindOf([CMAPICammentInRequest class]);
                                                                            expect(obj.uuid).to.equal(cammentToUpload.uuid);
                                                                            return YES;
                                                                        }]]);
            OCMExpect([outputMock interactorDidUploadCamment:[OCMArg checkWithBlock:^BOOL(CMCamment *obj) {
                expect(obj).toNot.beNil();
                expect(obj).to.beKindOf([CMCamment class]);
                expect(obj.uuid).to.equal(cammentToUpload.uuid);
                return YES;
            }]]);

            [cammentViewInteractor uploadCamment:cammentToUpload];

            OCMVerifyAllWithDelay(outputMock, 10);
        });


    });

SpecEnd


