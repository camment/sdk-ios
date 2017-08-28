//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const CMS3TransferManagerName;
extern NSString* const CMIotManagerName;
extern NSString* const CMAPIClientName;

@interface CMAppConfig : NSObject

@property (nonatomic, strong, readonly) NSString *awsCognitoIdenityPoolId;
@property (nonatomic, strong, readonly) NSString *awsS3BucketName;
@property (nonatomic, strong, readonly) NSString *hockeyAppId;
@property (nonatomic, strong, readonly) NSString *fbAppId;

+ (CMAppConfig *)instance;


@end
