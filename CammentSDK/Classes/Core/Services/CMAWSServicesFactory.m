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
#import "CMAPIDevcammentClient+defaultApiClient.h"
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
        [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:CMAnonymousAPIClientName];
        self.anonymousAPIClient = [CMAPIDevcammentClient clientForKey:CMAnonymousAPIClientName];
        [self.anonymousAPIClient setAPIKey:appConfig.apiKey];
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
                                           initWithKeepAliveTimeInterval:60.0
                                           baseReconnectTimeInterval:1.0
                                           minimumConnectionTimeInterval:20.0
                                           maximumReconnectTimeInterval:128.0
                                           runLoop:[NSRunLoop mainRunLoop]
                                           runLoopMode:NSDefaultRunLoopMode
                                           autoResubscribe:YES
                                           lastWillAndTestament:[AWSIoTMQTTLastWillAndTestament new]];
    [AWSIoTDataManager registerIoTDataManagerWithConfiguration:iotConfiguration
                                         withMQTTConfiguration:mqttConfig
                                                        forKey:CMIotManagerName];
    self.IoTDataManager = [AWSIoTDataManager IoTDataManagerForKey:CMIotManagerName];
    
    [CMAPIDevcammentClient registerClientWithConfiguration:configuration forKey:CMAPIClientName];
    self.APIClient = [CMAPIDevcammentClient clientForKey:CMAPIClientName];
    [self.APIClient setAPIKey:self.appConfig.apiKey];

    self.cognitoHasBeenConfigured = YES;
}

@end
