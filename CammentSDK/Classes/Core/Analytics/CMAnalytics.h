//
// Created by Alexander Fedosov on 23.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMAnalytics : NSObject

+ (CMAnalytics *)instance;

- (void)configureAWSMobileAnalytics;

@end