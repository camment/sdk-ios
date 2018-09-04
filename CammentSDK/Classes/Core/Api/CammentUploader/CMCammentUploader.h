//
// Created by Alexander Fedosov on 22.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AWSS3TransferManager;
@class RACSignal;

@interface CMCammentUploader : NSObject

- (instancetype)initWithBucketName:(NSString *)bucketName;

- (RACSignal *)uploadVideoAsset:(NSURL *)url uuid:(NSString *)uuid;

@end
