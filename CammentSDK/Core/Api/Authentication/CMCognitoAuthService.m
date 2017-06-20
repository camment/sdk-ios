//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CMCognitoAuthService.h"
#import "CMAppConfig.h"


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
}

- (RACSignal *)signIn {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AWSCancellationToken *cancellationToken = [AWSCancellationToken new];

        [[_credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask<id> *task) {
            if (task.error) {
                [subscriber sendError:task.error];
                return nil;
            }

            [[_credentialsProvider credentials] continueWithBlock:^id(AWSTask<id> *t) {
                if (t.error) {
                    [subscriber sendError:t.error];
                } else {
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
