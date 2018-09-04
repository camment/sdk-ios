//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMAppConfig.h"

NSString* const CMS3TransferManagerName = @"defaultTransferManager";
NSString* const CMIotManagerName = @"defaultIotManager";
NSString* const CMAPIClientName = @"defaultApiClient";
NSString* const CMAnonymousAPIClientName = @"anonymousApiClient";
NSString* const CMCognitoName = @"defaultCognito";

@implementation CMAppConfig

- (instancetype)init:(NSString *)sdkEnvironment {
    self = [super init];
    if (self) {
        NSString *propertyListPath = [[NSBundle cammentSDKBundle] pathForResource:@"Config" ofType:@"plist"];
        NSDictionary *propertyList = [NSDictionary dictionaryWithContentsOfFile:propertyListPath];
        _sdkEnvironment = sdkEnvironment;
        DDLogDeveloperInfo(@"SDK environment %@", _sdkEnvironment);
        NSDictionary *envPropertyList = [propertyList valueForKey:_sdkEnvironment];
        DDLogInfo(@"env config %@", envPropertyList);
        _awsCognitoIdenityPoolId = [envPropertyList valueForKey:@"awsCognitoPoolId"] ?: @"";
        _awsS3BucketName = [envPropertyList valueForKey:@"awsS3BucketName"] ?: @"";
        _apiHost = [envPropertyList valueForKey:@"apiHost"] ?: @"";
        _iotCertFile = [envPropertyList valueForKey:@"iotCertFile"] ?: @"";
        _iotCertPassPhrase = [envPropertyList valueForKey:@"iotCertPassPhrase"] ?: @"";
        _iotHost = [envPropertyList valueForKey:@"iotHost"] ?: @"";
    }
    return self;
}

@end
