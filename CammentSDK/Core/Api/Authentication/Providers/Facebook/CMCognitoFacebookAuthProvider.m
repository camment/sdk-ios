//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AWSCore/AWSCore.h>
#import "CMCognitoFacebookAuthProvider.h"

@implementation CMCognitoFacebookAuthProvider

- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    FBSDKAccessToken* fbToken = [FBSDKAccessToken currentAccessToken];
    NSDictionary *logins;

    if(fbToken) {
        NSString *token = fbToken.tokenString;
        logins = token ? @{ AWSIdentityProviderFacebook : token } : @{};
    } else {
        logins = @{};
    }

    return [AWSTask taskWithResult: logins];
}

@end