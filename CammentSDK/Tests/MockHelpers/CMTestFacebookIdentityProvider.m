//
//  CMTestFacebookIdentityProvider.m
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 20.11.2017.
//

#import "CMTestFacebookIdentityProvider.h"

@implementation CMTestFacebookIdentityProvider

- (void)refreshUserIdentity:(CMIdentityProviderIdentityBlock _Nonnull)identityBlock forceSignin:(BOOL)forceSignin {
    if (!_facebookAccessToken) {
        identityBlock(@{});
        return;
    }

    identityBlock(@{
            CMCammentIdentityProviderFacebook : _facebookAccessToken
    });
}

- (void)logOut {

}

@end
