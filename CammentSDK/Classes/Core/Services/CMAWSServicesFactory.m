//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSIoT/AWSIoT.h>
#import "AWSCognito.h"
#import "CMAWSServicesFactory.h"
#import "CMAppConfig.h"
#import "AWSS3TransferManager.h"
#import "CMAPIDevcammentClient.h"
#import "CMStore.h"
#import "CMCognitoFacebookAuthProvider.h"
#import "CMCognitoFacebookAuthProvider.h"

@interface CMAWSServicesFactory ()

@property(nonatomic, strong) CMAppConfig *appConfig;

@end

@implementation CMAWSServicesFactory


- (instancetype)initWithAppConfig:(CMAppConfig *)appConfig {
    self = [super init];
    if (self) {

        self.appConfig = appConfig;
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                             credentialsProvider:nil];
        [CMAPIDevcammentClient registerClientWithConfiguration:configuration
                                                        forKey:CMAnonymousAPIClientName
                                                     appConfig:self.appConfig];
        self.anonymousAPIClient = [CMAPIDevcammentClient clientForKey:CMAnonymousAPIClientName];
        [self.anonymousAPIClient setAPIKey:appConfig.apiKey];

        self.cognitoFacebookIdentityProvider = [[CMCognitoFacebookAuthProvider alloc] initWithRegionType:AWSRegionEUCentral1
                                                                                          identityPoolId:self.appConfig.awsCognitoIdenityPoolId
                                                                                         useEnhancedFlow:YES
                                                                                 identityProviderManager:nil
                                                                                               APIClient:self.anonymousAPIClient];
        self.cognitoCredentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionEUCentral1
                                                                                   identityProvider:self.cognitoFacebookIdentityProvider];
    }

    return self;
}

- (void)configureAWSServices:(AWSCognitoCredentialsProvider *)credentialsProvider {
    _awsCognitoCredentialsProvider = credentialsProvider;

    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                         credentialsProvider:_awsCognitoCredentialsProvider];

    [AWSCognito registerCognitoWithConfiguration:configuration forKey:CMCognitoName];
    [AWSS3TransferManager registerS3TransferManagerWithConfiguration:configuration forKey:CMS3TransferManagerName];
    self.s3TransferManager = [AWSS3TransferManager S3TransferManagerForKey:CMS3TransferManagerName];

    AWSEndpoint *iotEndpoint = [[AWSEndpoint alloc] initWithURLString:_appConfig.iotHost];
    AWSServiceConfiguration *iotConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionEUCentral1
                                                                                       endpoint:iotEndpoint
                                                                            credentialsProvider:_awsCognitoCredentialsProvider];

    AWSIoTMQTTConfiguration *mqttConfig = [[AWSIoTMQTTConfiguration alloc]
            initWithKeepAliveTimeInterval:5.0
                baseReconnectTimeInterval:1.0
            minimumConnectionTimeInterval:5.0
             maximumReconnectTimeInterval:20.0
                                  runLoop:[NSRunLoop mainRunLoop]
                              runLoopMode:NSDefaultRunLoopMode
                          autoResubscribe:YES
                     lastWillAndTestament:[AWSIoTMQTTLastWillAndTestament new]];
    [AWSIoTDataManager registerIoTDataManagerWithConfiguration:iotConfiguration
                                         withMQTTConfiguration:mqttConfig
                                                        forKey:CMIotManagerName];
    self.IoTDataManager = [AWSIoTDataManager IoTDataManagerForKey:CMIotManagerName];

    [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:CMAPIClientName appConfig:self.appConfig];
    self.APIClient = [CMAPIDevcammentClient clientForKey:CMAPIClientName];
    [self.APIClient setAPIKey:self.appConfig.apiKey];

    self.cognitoHasBeenConfigured = YES;
}

@end
