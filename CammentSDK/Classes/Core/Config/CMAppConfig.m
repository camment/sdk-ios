//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMAppConfig.h"

NSString* const CMS3TransferManagerName = @"defaultTransferManager";
NSString* const CMIotManagerName = @"defaultIotManager";
NSString* const CMAPIClientName = @"defaultApiClient";

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
        _awsCognitoIdenityPoolId = [propertyList valueForKey:@"awsCognitoPoolId"] ?: @"";
        _awsS3BucketName = [propertyList valueForKey:@"awsS3BucketName"] ?: @"";
        _hockeyAppId = [propertyList valueForKey:@"hockeyAppId"] ?: @"";
        _fbAppId = [propertyList valueForKey:@"facebookAppId"] ?: @"";
    }
    return self;
}

@end
