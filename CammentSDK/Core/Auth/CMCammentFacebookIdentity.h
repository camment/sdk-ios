//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CammentSDK/CMCammentIdentity.h>


@interface CMCammentFacebookIdentity: CMCammentIdentity

@property (nonatomic, strong) id fbsdkAccessToken;

+(CMCammentFacebookIdentity *)identityWithFBSDKAccessToken:(id)token;

@end
