//
//  CMLoginCMLoginInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMAuthInteractor.h"
#import "CMStore.h"
#import "CMCognitoAuthService.h"

@implementation CMAuthInteractor

- (void)signInWithFacebookProvider:(UIViewController *)viewController {
    self.manager = [FBSDKLoginManager new];

    @weakify(self);
    [self.manager logInWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"read_custom_friendlists"]
                   fromViewController:viewController
                              handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                  @strongify(self);
                                  if (!self) { return; }
                                  
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
