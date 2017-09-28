//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CammentSDK/CMCammentIdentity.h>

@class FBSDKAccessToken;


@interface CMCammentFacebookIdentity: CMCammentIdentity

@property (nonatomic, strong, readonly) id fbsdkAccessToken;

- (instancetype)initWithFBSDKtoken:(FBSDKAccessToken *)token NS_DESIGNATED_INITIALIZER;

+ (CMCammentFacebookIdentity *)identityWithFBSDKAccessToken:(id)token;

@end
