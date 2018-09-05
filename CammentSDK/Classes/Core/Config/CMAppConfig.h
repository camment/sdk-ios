//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const CMS3TransferManagerName;
extern NSString* const CMIotManagerName;
extern NSString* const CMAPIClientName;
extern NSString* const CMAnonymousAPIClientName;
extern NSString* const CMCognitoName;

@interface CMAppConfig : NSObject

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, strong, readonly) NSString *sdkEnvironment;
@property (nonatomic, strong, readonly) NSString *awsCognitoIdenityPoolId;
@property (nonatomic, strong, readonly) NSString *awsS3BucketName;
@property (nonatomic, strong, readonly) NSString *apiHost;
@property (nonatomic, strong, readonly) NSString *iotCertFile;
@property (nonatomic, strong, readonly) NSString *iotHost;

@property(nonatomic, copy) NSString *iotCertPassPhrase;


- (instancetype)init:(NSString *)sdkEnvironment;

@end
