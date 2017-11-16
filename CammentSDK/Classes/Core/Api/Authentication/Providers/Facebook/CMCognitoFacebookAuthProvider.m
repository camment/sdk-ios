//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSCore/AWSCore.h>
#import "CMCognitoFacebookAuthProvider.h"
#import "CMStore.h"

@implementation CMCognitoFacebookAuthProvider

- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    NSDictionary *logins = @{};

    if ([CMStore instance].tokens && [CMStore instance].tokens[CMCammentIdentityProviderFacebook]) {
        NSString *token = [CMStore instance].tokens[CMCammentIdentityProviderFacebook];
        logins =  @{ AWSIdentityProviderFacebook : token };
    }
    return [AWSTask taskWithResult:logins];
}

@end
