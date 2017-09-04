//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentFacebookIdentity.h"
#import "FBSDKAccessToken.h"
#import <FBSDKCoreKit/FBSDKAccessToken.h>

@implementation CMCammentFacebookIdentity

- (instancetype)init {
    return [self initWithFBSDKtoken:nil];
}

- (instancetype)initWithFBSDKtoken:(FBSDKAccessToken *)token {
    self = [super init];

    if (self) {
        _fbsdkAccessToken = token;
    }

    return self;
}

+ (CMCammentFacebookIdentity *)identityWithFBSDKAccessToken:(FBSDKAccessToken *)token {
    return [[CMCammentFacebookIdentity alloc] initWithFBSDKtoken:token];
}

@end
