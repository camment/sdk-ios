//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "CMCammentIdentity.h"


@interface CMCammentFacebookIdentity: CMCammentIdentity

@property (nonatomic, strong) FBSDKAccessToken *fbsdkAccessToken;

+(CMCammentFacebookIdentity *)identityWithFBSDKAccessToken:(FBSDKAccessToken *)token;

@end