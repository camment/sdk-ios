//
// Created by Alexander Fedosov on 15.11.2017.
//

#import "CMFacebookIdentityProvider.h"
#import "FBSDKLoginManager.h"
#import "FBSDKAccessToken.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation CMFacebookIdentityProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fbsdkLoginManager = [FBSDKLoginManager new];
        self.fbsdkLoginManager.loginBehavior = FBSDKLoginBehaviorNative;
    }

    return self;
}

- (void)signIn:(CMIdentityProviderTokensBlock)tokensBlock {

    if (!self.viewController) {
        self.viewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    }
    
    [self.fbsdkLoginManager logInWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"read_custom_friendlists"]
                                  fromViewController:self.viewController
                                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {

                                                 NSMutableDictionary<NSString *, id> *tokens = [NSMutableDictionary new];
                                                 if (result.token) {
                                                     tokens[CMCammentIdentityProviderFacebook] = result.token.tokenString;
                                                 }

                                                 if (tokensBlock) {
                                                     tokensBlock(tokens);
                                                 }
                                             }];
}

- (void)signOut {
    [[FBSDKLoginManager new] logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];
}
@end
