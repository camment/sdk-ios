//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSIoT/AWSIoT.h>
#import "AWSCognito.h"
#import "CMCognitoAuthService.h"
#import "CMAppConfig.h"
#import "AWSS3TransferManager.h"
#import "CMAPIDevcammentClient.h"
#import "CMStore.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMCognitoFacebookAuthProvider.h"

@interface CMCognitoAuthService ()
@property(nonatomic, strong) AWSCognitoCredentialsProvider *credentialsProvider;
@end

@implementation CMCognitoAuthService


- (instancetype)init {
    self = [super init];
    if (self) {
        self.credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                initWithRegionType:AWSRegionEUCentral1
                    identityPoolId:[CMAppConfig instance].awsCognitoIdenityPoolId
           identityProviderManager:[CMCognitoFacebookAuthProvider new]];
    }

    return self;
}

- (void)updateAWSServicesConfiguration {
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                         credentialsProvider:_credentialsProvider];

    [AWSCognito registerCognitoWithConfiguration:configuration forKey:CMCognitoName];
    [AWSS3TransferManager registerS3TransferManagerWithConfiguration:configuration forKey:CMS3TransferManagerName];
    [AWSIoTDataManager registerIoTDataManagerWithConfiguration:configuration forKey:CMIotManagerName];
    [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:CMAPIClientName];
    [[CMAPIDevcammentClient defaultAPIClient] setAPIKey:[CMStore instance].apiKey];
    self.cognitoHasBeenConfigured = YES;
}

- (RACSignal<NSString *> *)signIn {
    __weak typeof(self) __weak_self = self;
    __block NSString *cognitoUserIdentity = @"";
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {

        AWSTask *getIdentityTask = [_credentialsProvider getIdentityId];
        [[getIdentityTask continueWithBlock:^id(AWSTask<id> *task) {

            if (task.error) {
                [subscriber sendError:task.error];
                return nil;
            }
            [__weak_self updateAWSServicesConfiguration];
            cognitoUserIdentity = [task result];

            return [[CMAPIDevcammentClient defaultAPIClient] userinfoGet];
        } cancellationToken:nil] continueWithBlock:^id(AWSTask<id> *task) {

            if (task.error) {
                [subscriber sendError:task.error];
                return nil;
            }

            [subscriber sendNext:cognitoUserIdentity];

            return nil;
        }];
        return nil;
    }];
}

- (RACSignal<NSString *> *)refreshCredentials {
    [_credentialsProvider clearCredentials];
    return [self signIn];
}

- (void)signOut {
    [_credentialsProvider clearKeychain];
}

- (BOOL)isSignedIn {
    return _credentialsProvider.identityId != nil;
}

@end
