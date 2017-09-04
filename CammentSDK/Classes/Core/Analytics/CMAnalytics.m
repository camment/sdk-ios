//
// Created by Alexander Fedosov on 23.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSCore/AWSCore.h>
#import <AWSMobileAnalytics/AWSMobileAnalytics.h>
#import "CMAnalytics.h"


@interface CMAnalytics ()
@property(nonatomic, strong) AWSMobileAnalytics *analytics;
@end

@implementation CMAnalytics

+ (CMAnalytics *)instance {
    static CMAnalytics *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)configureAWSMobileAnalytics {
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
            initWithRegionType: AWSRegionUSEast1
                identityPoolId: @"us-east-1:71549a59-04b7-4924-9973-0c35c9278e78"];
    AWSServiceConfiguration *serviceConfiguration = [[AWSServiceConfiguration alloc]
            initWithRegion: AWSRegionUSEast1
       credentialsProvider: credentialsProvider];
    AWSMobileAnalyticsConfiguration *analyticsConfiguration = [[AWSMobileAnalyticsConfiguration alloc] init];
    [analyticsConfiguration setServiceConfiguration:serviceConfiguration];
    self.analytics = [AWSMobileAnalytics
            mobileAnalyticsForAppId: @"ea4151c5b77046bfb7213de5d02f514f" 
                      configuration: analyticsConfiguration];
}

@end