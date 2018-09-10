//
// Created by Alexander Fedosov on 15.11.2017.
//

#import "CMFacebookIdentityProvider.h"
#import "FBSDKLoginManager.h"
#import "FBSDKAccessToken.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <CammentSDK/CammentSDK.h>
@implementation CMFacebookIdentityProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fbsdkLoginManager = [FBSDKLoginManager new];
        self.fbsdkLoginManager.loginBehavior = FBSDKLoginBehaviorNative;
    }
    return self;
}

- (UIViewController *)viewController {
    if (_viewController) { return _viewController; };

    if ([CammentSDK instance].sdkUIDelegate && [[CammentSDK instance].sdkUIDelegate isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)[CammentSDK instance].sdkUIDelegate;
    }

    // Try to find correct view controller if it has not been provided
    UIViewController *topController = [[UIApplication sharedApplication].keyWindow rootViewController];
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }

    return topController;
}

- (NSString *)cachedToken {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (!token || !token.tokenString) { return nil; }

    NSDate *fbExpirationDate = token.expirationDate;
    if ([fbExpirationDate compare:[NSDate date]] != NSOrderedDescending) { return nil; }

    return token.tokenString;
}

- (void)refreshUserIdentity:(CMIdentityProviderIdentityBlock _Nonnull)tokensBlock forceSignin:(BOOL)forceSignin {

    // check if there is a valid facebook token
    NSString *token = [self cachedToken];
    if (token) {
        tokensBlock(@{
                CMCammentIdentityProviderFacebook: token
        });
        return;
    }

    // no valid fb token, but if forceSignIn = NO, we don't want to continue
    if (!forceSignin) {
        tokensBlock(@{});
        return;
    }

    [self.fbsdkLoginManager logInWithReadPermissions:@[@"public_profile", @"email"]
                                  fromViewController:self.viewController
                                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                 NSString *fbAccessToken = result.token.tokenString;
                                                 if (!fbAccessToken) {
                                                     tokensBlock(@{});
                                                     return;
                                                 } else {
                                                     tokensBlock(@{
                                                             CMCammentIdentityProviderFacebook: fbAccessToken
                                                     });
                                                 }
                                             }];
}

- (void)logOut {
    [[FBSDKLoginManager new] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
}

@end
