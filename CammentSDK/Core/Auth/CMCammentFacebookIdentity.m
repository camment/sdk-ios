//
// Created by Alexander Fedosov on 26.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentFacebookIdentity.h"


@implementation CMCammentFacebookIdentity {

}
+ (CMCammentFacebookIdentity *)identityWithFBSDKAccessToken:(FBSDKAccessToken *)token {
    CMCammentFacebookIdentity *identity = [self init];
    identity.fbsdkAccessToken = token;
    return identity;
}

@end