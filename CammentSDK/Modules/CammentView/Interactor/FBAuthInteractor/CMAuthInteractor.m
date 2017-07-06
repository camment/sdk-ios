//
//  CMLoginCMLoginInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CMAuthInteractor.h"
#import "CMStore.h"
#import "CMCognitoAuthService.h"

@implementation CMAuthInteractor

- (void)signInWithFacebookProvider:(UIViewController *)viewController {
    FBSDKLoginManager *manager = [FBSDKLoginManager new];
    manager.loginBehavior = FBSDKLoginBehaviorSystemAccount;

    [manager logInWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"read_custom_friendlists"]
                   fromViewController:viewController
                              handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                  if (error) {
                                      [self.output authInteractorFailedToSignIn:error];
                                      return;
                                  }

                                  if (result.token == nil) {
                                      [self.output authInteractorFailedToSignIn:[NSError errorWithDomain:@"ios.camment.tv" code:1 userInfo:nil]];
                                      return;
                                  }

                                  [self.output authInteractorDidSignedIn];
                              }];
}

@end
