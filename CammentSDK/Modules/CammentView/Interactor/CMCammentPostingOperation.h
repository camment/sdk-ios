//
// Created by Alexander Fedosov on 24.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Camment;
@class CMCammentUploader;
@class CMDevcammentClient;


@interface CMCammentPostingOperation: NSOperation

@property NSUInteger maxRetries;
@property NSUInteger retryNumber;
@property (copy) void (^postingCompletionBlock)(Camment *camment, NSError *error, CMCammentPostingOperation *operation);

- (instancetype)initWithCamment:(Camment *)camment cammentUploader:(CMCammentUploader *)cammentUploader cammentClient:(CMDevcammentClient *)cammentClient;

- (void)completeOperation;

@end
