//
//  CMCammentUploaderTests.m
//  CMCammentUploaderTests
//
//  Created by Alexander Fedosov on 13.11.2017.
//  Copyright © 2017 Sportacam. All rights reserved.
//

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <AWSS3/AWSS3.h>
#import "CMCammentUploader.h"

SpecBegin(CMCammentUploaderTests)

    __block AWSS3TransferManager *awss3TransferManager;
    __block CMCammentUploader *cammentUploader;
    NSString *bucketName = @"bucketName";

    describe(@"Camment uploader", ^{
        
        beforeEach(^{
            awss3TransferManager = OCMClassMock([AWSS3TransferManager class]);
            cammentUploader = [[CMCammentUploader alloc] initWithBucketName:bucketName
                                                        aws3TransferManager:awss3TransferManager];
        });
        
        it(@"should be created", ^{
            expect(cammentUploader).toNot.beNil();
            expect(cammentUploader).to.beKindOf([CMCammentUploader class]);
        });
        
        it(@"should return success", ^{
            AWSTask *uploadedSuccessfullyTask = [AWSTask taskWithResult:@{}];
            OCMStub([awss3TransferManager upload:[OCMArg isKindOfClass:[AWSS3TransferManagerUploadRequest class]]])
                    .andReturn(uploadedSuccessfullyTask);

            RACSignal *result = [cammentUploader uploadVideoAsset:[NSURL URLWithString:@"http://camment.tv"] uuid:[NSUUID new].UUIDString];

            waitUntil(^(DoneCallback done) {
                [result subscribeError:^(NSError *error) {
                    failure([NSString stringWithFormat:@"Fail with error %@", error]);
                }            completed:^{
                    done();
                }];
            });
        });

        it(@"should return error", ^{
            NSError *uploadingError = [[NSError alloc] initWithDomain:AWSS3TransferManagerErrorDomain
                                                                 code:AWSS3TransferManagerErrorInternalInConsistency
                                                             userInfo:@{}];
            AWSTask *uploadFailedTask = [AWSTask taskWithError:uploadingError];

            OCMStub([awss3TransferManager upload:[OCMArg isKindOfClass:[AWSS3TransferManagerUploadRequest class]]])
                    .andReturn(uploadFailedTask);

            RACSignal *result = [cammentUploader uploadVideoAsset:[NSURL URLWithString:@"http://camment.tv"] uuid:[NSUUID new].UUIDString];

            waitUntil(^(DoneCallback done) {
                [result subscribeError:^(NSError *error) {
                    expect(error).to.beIdenticalTo(uploadingError);
                    done();
                }            completed:^{
                    failure(@"Test case should fail with error");
                }];
            });
        });

    });

SpecEnd


