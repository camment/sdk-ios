//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AWSIoT/AWSIoT.h>
#import "CMCognitoAuthService.h"
#import "CMAppConfig.h"
#import "AWSS3TransferManager.h"
#import "AWSIoTDataManager.h"
#import "CMAPIDevcammentClient.h"
#import "CMStore.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"


@interface CMCognitoAuthService ()

@property(nonatomic, strong) AWSCognitoCredentialsProvider *credentialsProvider;

@end

@implementation CMCognitoAuthService

- (void)configureWithProvider:(id <AWSIdentityProviderManager>)provider {

    if (!provider) {
        return;
    }

    self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
            initWithRegionType:AWSRegionEUCentral1
                identityPoolId:[CMAppConfig instance].awsCognitoIdenityPoolId
       identityProviderManager:provider];

    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                         credentialsProvider:_credentialsProvider];

    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    [AWSS3TransferManager registerS3TransferManagerWithConfiguration:configuration forKey:CMS3TransferManagerName];
    [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:CMAPIClientName];
    [[CMAPIDevcammentClient defaultAPIClient] setAPIKey:[CMStore instance].apiKey];
    [AWSIoTDataManager registerIoTDataManagerWithConfiguration:configuration forKey:CMIotManagerName];
}

- (RACSignal *)signIn {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        AWSCancellationToken *cancellationToken = [AWSCancellationToken new];

        [[_credentialsProvider getIdentityId] continueWithBlock:^id(AWSTask<id> *task) {
            if (task.error) {
                [subscriber sendError:task.error];
                return nil;
            } else {
                NSString *cognitoUserIdentity = [task result];
                [subscriber sendNext:cognitoUserIdentity];
                [subscriber sendCompleted];
            }

            return nil;
        }                                     cancellationToken:cancellationToken];
        return nil;
    }];
}

- (void)refreshIdentity {
    [_credentialsProvider clearCredentials];
}

- (void)signOut {
    [_credentialsProvider clearCredentials];
    [_credentialsProvider clearKeychain];
}

- (BOOL)isSignedIn {
    return [FBSDKAccessToken currentAccessToken] != nil;
}

@end
