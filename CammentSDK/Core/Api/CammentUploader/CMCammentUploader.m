//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import <AVFoundation/AVFoundation.h>
#import <AWSS3/AWSS3.h>

#import "CMCammentUploader.h"
#import "CMAppConfig.h"
#import "CMDevcammentClient.h"

@interface CMCammentUploader ()
@property(nonatomic, copy) NSString *bucketName;
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
    self = [super init];

    if (self) {
        self.bucketName = [CMAppConfig instance].awsS3BucketName;
    }

    return self;
}

- (RACSignal *)uploadVideoAsset:(NSURL *)url uuid:(NSString *)uuid {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];

        uploadRequest.bucket = self.bucketName;
        NSString *fileKey = [NSString stringWithFormat:@"%@.mp4", uuid];
        uploadRequest.key = fileKey;
        uploadRequest.body = url;
        uploadRequest.contentLength = @([NSData dataWithContentsOfURL:url].length);
        uploadRequest.storageClass = AWSS3StorageClassReducedRedundancy;
        uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            [subscriber sendNext:@(1.0f / totalBytesExpectedToSend * bytesSent)];
        };
        AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
        [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask<id> *task) {
            if (task.error) {
                if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                    switch (task.error.code) {
                        case AWSS3TransferManagerErrorCancelled:
                        case AWSS3TransferManagerErrorPaused:
                            break;

                        default:
                            NSLog(@"Error: %@", task.error);
                            break;
                    }
                } else {
                    // Unknown error.
                    NSLog(@"Error: %@", task.error);
                }
                [subscriber sendError:task.error];
            }

            if (task.result) {
                AWSS3TransferManagerUploadOutput *uploadOutput = task.result;
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
