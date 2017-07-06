//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CMCognitoAuthService.h"
#import "CMAppConfig.h"
#import "AWSS3TransferManager.h"
#import "AWSIoTDataManager.h"

@interface CMCognitoAuthService ()

@property(nonatomic, strong) AWSCognitoCredentialsProvider *credentialsProvider;

@end

@implementation CMCognitoAuthService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionEUCentral1
                                                                              identityPoolId:[CMAppConfig instance].awsCognitoIdenityPoolId];

        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1 credentialsProvider:_credentialsProvider];
        AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
        [AWSS3TransferManager registerS3TransferManagerWithConfiguration:configuration forKey:CMS3TransferManagerName];
        [AWSIoTDataManager registerIoTDataManagerWithConfiguration:configuration forKey:CMIotManagerName];
    }

    return self;
}

- (void)configureWithProvider:(id <AWSIdentityProviderManager>)provider {
    self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                initWithRegionType:AWSRegionEUCentral1
                                identityPoolId:[CMAppConfig instance].awsCognitoIdenityPoolId
                                identityProviderManager:provider];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1 credentialsProvider:_credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    [AWSS3TransferManager registerS3TransferManagerWithConfiguration:configuration forKey:CMS3TransferManagerName];
}

- (RACSignal *)signIn {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AWSCancellationToken *cancellationToken = [AWSCancellationToken new];

        [[_credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask<id> *task) {
            if (task.error) {
                [subscriber sendError:task.error];
                return nil;
            }

            NSString *cognitoUserIdentity = [task result];
            [[_credentialsProvider credentials] continueWithBlock:^id(AWSTask<id> *t) {
                if (t.error) {
                    [subscriber sendError:t.error];
                } else {
                    [subscriber sendNext:cognitoUserIdentity];
                    [subscriber sendCompleted];
                }
                return nil;
            }];

            return nil;
        } cancellationToken:cancellationToken];
        return nil;
    }];
}

- (void)refreshIdentity {
    [_credentialsProvider clearCredentials];
}

- (void)signOut {
    [_credentialsProvider clearCredentials];
}

- (BOOL)isSignedIn {
    return [FBSDKAccessToken currentAccessToken] != nil;
}


@end
