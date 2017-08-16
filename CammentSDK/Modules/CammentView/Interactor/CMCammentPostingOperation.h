//
// Created by Alexander Fedosov on 24.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMCamment;
@class CMCammentUploader;
@class CMAPIDevcammentClient;


@interface CMCammentPostingOperation: NSOperation

@property NSUInteger maxRetries;
@property NSUInteger retryNumber;
@property (copy) void (^postingCompletionBlock)(CMCamment *camment, NSError *error, CMCammentPostingOperation *operation);

- (instancetype)initWithCamment:(CMCamment *)camment cammentUploader:(CMCammentUploader *)cammentUploader cammentClient:(CMAPIDevcammentClient *)cammentClient;

- (void)completeOperation;

@end
