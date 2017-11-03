//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMAppConfig.h"

NSString* const CMS3TransferManagerName = @"defaultTransferManager";
NSString* const CMIotManagerName = @"defaultIotManager";
NSString* const CMAPIClientName = @"defaultApiClient";
NSString* const CMCognitoName = @"defaultCognito";

@implementation CMAppConfig

+ (CMAppConfig *)instance {
    static CMAppConfig *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *propertyListPath = [[NSBundle cammentSDKBundle] pathForResource:@"Config" ofType:@"plist"];
        NSDictionary *propertyList = [NSDictionary dictionaryWithContentsOfFile:propertyListPath];
        _sdkEnvironment = (NSString *) CMSDKEnvironment;
        NSLog(@"active sdk environment %@", _sdkEnvironment);
        NSDictionary *envPropertyList = [propertyList valueForKey:_sdkEnvironment];
        DDLogInfo(@"env config %@", envPropertyList);
        _awsCognitoIdenityPoolId = [envPropertyList valueForKey:@"awsCognitoPoolId"] ?: @"";
        _awsS3BucketName = [envPropertyList valueForKey:@"awsS3BucketName"] ?: @"";
        _hockeyAppId = [envPropertyList valueForKey:@"hockeyAppId"] ?: @"";
        _fbAppId = [envPropertyList valueForKey:@"facebookAppId"] ?: @"";
        _apiHost = [envPropertyList valueForKey:@"apiHost"] ?: @"";
        _iotCertFile = [envPropertyList valueForKey:@"iotCertFile"] ?: @"";
        _iotCertPassPhrase = [envPropertyList valueForKey:@"iotCertPassPhrase"] ?: @"";
        _iotHost = [envPropertyList valueForKey:@"iotHost"] ?: @"";
    }
    return self;
}

@end
