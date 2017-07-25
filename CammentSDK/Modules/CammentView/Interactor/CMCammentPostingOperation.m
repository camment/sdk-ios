//
// Created by Alexander Fedosov on 24.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentPostingOperation.h"
#import "Camment.h"
#import "UsersGroup.h"
#import "CMStore.h"
#import "RACSignal+SignalHelpers.h"
#import "CMCammentUploader.h"
#import "CMDevcammentClient.h"
#import "CammentBuilder.h"
#import <ReactiveObjC.h>

@interface CMCammentPostingOperation ()

@property(nonatomic) BOOL _finished;
@property(nonatomic) BOOL _executing;
@property(nonatomic, strong) CMCammentUploader *cammentUploader;
@property(nonatomic, strong) CMDevcammentClient *cammentClient;
@property(nonatomic, strong) Camment *cammentToUpload;
@property(nonatomic, strong) NSError *operationError;

@end

@implementation CMCammentPostingOperation {

}

- (instancetype)initWithCamment:(Camment *)camment
                cammentUploader:(CMCammentUploader *)cammentUploader
                  cammentClient:(CMDevcammentClient *)cammentClient {
    self = [super init];

    if (self) {
        self.maxRetries = 1;
        self.retryNumber = 1;
        self.cammentToUpload = camment;
        self.cammentUploader = cammentUploader;
        self.cammentClient = cammentClient;
    }

    return self;
}

- (void)start {
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        self._finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    self._executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)main {
    if ([self isCancelled]) {
        return;
    }

    [self uploadCamment:self.cammentToUpload];
}

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self._executing;
}

- (BOOL)isFinished {
    return self._finished;
}

- (void)completeOperation {

    if (self.operationError.code == -1109 && self.retryNumber + 1 < self.maxRetries) {
        [NSThread sleepForTimeInterval:10];
        self.retryNumber++;
        DDLogInfo(@"Trying to upload camment");
        [self uploadCamment:self.cammentToUpload];
        return;
    }

    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];

    self._executing = NO;
    self._finished = YES;

    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];

    if (self.postingCompletionBlock) {
        self.postingCompletionBlock(_cammentToUpload, _operationError, self);
    }
}

- (void)uploadCamment:(Camment *)camment {
    [[self.cammentUploader uploadVideoAsset:[[NSURL alloc] initWithString:camment.localURL]
                                       uuid:camment.uuid]
            subscribeError:^(NSError *error) {
                self.operationError = error;
                [self completeOperation];
            } completed:^{
        CMCammentInRequest *cammentInRequest = [[CMCammentInRequest alloc] init];
        cammentInRequest.uuid = camment.uuid;
        DDLogVerbose(@"Posting camment %@", camment);

        [[self.cammentClient usergroupsGroupUuidCammentsPost:camment.userGroupUuid
                                                        body:cammentInRequest]
                continueWithBlock:^id(AWSTask<CMCamment *> *t) {
                    if (t.error) {
                        self.operationError = t.error;
                    } else {
                        CMCamment *cmCamment = t.result;
                        Camment *uploadedCamment = [[[[[[[CammentBuilder cammentFromExistingCamment:camment]
                                withUuid:cmCamment.uuid]
                                withShowUuid:cmCamment.showUuid]
                                withRemoteURL:cmCamment.url]
                                withUserGroupUuid:cmCamment.userGroupUuid]
                                withLocalURL:nil]
                                build];
                        DDLogVerbose(@"Camment has been sent %@", uploadedCamment);
                    }
                    [self completeOperation];
                    return nil;
                }];
    }];
}

@end