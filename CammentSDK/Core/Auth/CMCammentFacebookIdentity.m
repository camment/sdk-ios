//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentFacebookIdentity.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>

@implementation CMCammentFacebookIdentity

+ (CMCammentFacebookIdentity *)identityWithFBSDKAccessToken:(FBSDKAccessToken *)token {
    CMCammentFacebookIdentity *identity = [CMCammentFacebookIdentity new];
    identity.fbsdkAccessToken = token;
    return identity;
}

@end
