//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <AVFoundation/AVFoundation.h>
#import <AWSS3/AWSS3.h>

#import "CMCammentUploader.h"
#import "CMAppConfig.h"
#import "CMAPIDevcammentClient.h"

@interface CMCammentUploader ()

@property(nonatomic, copy) NSString *bucketName;
@property(nonatomic, strong) AWSS3TransferManager *transferManager;

@end

@implementation CMCammentUploader

+ (CMCammentUploader *)instance {
    static CMCammentUploader *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    return [self initWithBucketName:[CMAppConfig instance].awsS3BucketName
                aws3TransferManager:[AWSS3TransferManager S3TransferManagerForKey:CMS3TransferManagerName]];
}

- (instancetype)initWithBucketName:(NSString *)bucketName aws3TransferManager:(AWSS3TransferManager *)awss3TransferManager {
    self = [super init];

    if (self) {
        self.bucketName = bucketName;
        self.transferManager = awss3TransferManager;
    }
    
    return self;
}

- (RACSignal *)uploadVideoAsset:(NSURL *)url uuid:(NSString *)uuid {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
        uploadRequest.bucket = self.bucketName;
        NSString *fileKey = [NSString stringWithFormat:@"uploads/%@.mp4", uuid];
        uploadRequest.key = fileKey;
        uploadRequest.body = url;
        uploadRequest.contentType = @"video/mp4";
        uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
        uploadRequest.storageClass = AWSS3StorageClassStandardIa;
        uploadRequest.contentLength = @([NSData dataWithContentsOfURL:url].length);
        uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            [subscriber sendNext:@(1.0f / totalBytesExpectedToSend * bytesSent)];
        };

        if (!self.transferManager) {
            _transferManager = [AWSS3TransferManager S3TransferManagerForKey:CMS3TransferManagerName];
        }
        
        [[self.transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask<id> *task) {
            if (task.error) {
                if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                    switch ((AWSS3TransferManagerErrorType)task.error.code) {
                        case AWSS3TransferManagerErrorCancelled: break;
                        case AWSS3TransferManagerErrorPaused:break;
                        case AWSS3TransferManagerErrorUnknown:break;
                        case AWSS3TransferManagerErrorCompleted:break;
                        case AWSS3TransferManagerErrorInternalInConsistency:break;
                        case AWSS3TransferManagerErrorMissingRequiredParameters:break;
                        case AWSS3TransferManagerErrorInvalidParameters:break;
                    }
                }

                DDLogError(@"Uploading camment failed with error %@", task.error);
                [subscriber sendError:task.error];
            }

            if (task.result) {
                [subscriber sendCompleted];
            }
            return nil;
        }];

        return [RACDisposable disposableWithBlock:^{
            [[uploadRequest cancel] continueWithBlock:^id(AWSTask<id> *t) {
                return nil;
            }];
        }];
    }];
}

@end
