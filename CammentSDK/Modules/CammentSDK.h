//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMCammentIdentity;


@interface CammentSDK: NSObject
+ (CammentSDK *)instance;

- (void)configureWithApiKey:(NSString *)apiKey;
- (void)connectUserWithIdentity:(CMCammentIdentity *)identity;
@end