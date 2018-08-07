//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCognitoIdentity.h>
#import <AWSS3/AWSS3.h>
#import <AWSIoT/AWSIoT.h>
#import "AWSIoTDataManager.h"
#import <ReactiveObjC/ReactiveObjC.h>

@class CMCognitoFacebookAuthProvider;
@class CMAppConfig;
@class CMAPIDevcammentClient;

@interface CMAWSServicesFactory: NSObject

@property BOOL cognitoHasBeenConfigured;

@property(nonatomic, strong, readonly) AWSCognitoCredentialsProvider *awsCognitoCredentialsProvider;

@property(nonatomic, strong) CMAPIDevcammentClient *anonymousAPIClient;

@property(nonatomic, strong) AWSS3TransferManager *s3TransferManager;

@property(nonatomic, strong) AWSIoTDataManager *IoTDataManager;

@property(nonatomic, strong) CMAPIDevcammentClient *APIClient;

@property(nonatomic, strong) CMCognitoFacebookAuthProvider *cognitoFacebookIdentityProvider;

@property(nonatomic, strong) AWSCognitoCredentialsProvider *cognitoCredentialsProvider;

- (instancetype)initWithAppConfig:(CMAppConfig *)appConfig;

- (void)configureAWSServices:(AWSCognitoCredentialsProvider *)credentialsProvider;
@end
