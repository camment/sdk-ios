//
// Created by Alexander Fedosov on 15.11.2017.
//

#import "CMFacebookIdentityProvider.h"
#import "FBSDKLoginManager.h"
#import "FBSDKAccessToken.h"
#import "FBSDKGraphRequest.h"
#import "FBSDKProfilePictureView.h"
#import "FBSDKProfile.h"
#import "CammentSDK.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

typedef void(^CMFBProfileDataFetcherBlock)(NSDictionary<NSString *, NSString *> * _Nonnull fbProfileData);

@implementation CMFacebookIdentityProvider

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fbsdkLoginManager = [FBSDKLoginManager new];
        self.fbsdkLoginManager.loginBehavior = FBSDKLoginBehaviorNative;
        [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateProfile)
                                                     name:FBSDKProfileDidChangeNotification
                                                   object:nil];
    }

    return self;
}

- (void)updateProfile {
    [[CammentSDK instance] refreshUserIdentity:NO];
}

- (UIViewController *)viewController {
    if (_viewController) { return _viewController; };
    return [[UIApplication sharedApplication].keyWindow rootViewController];
}

- (void)getUserProfile:(CMFBProfileDataFetcherBlock)completion {

    FBSDKProfile *profile = [FBSDKProfile currentProfile];
    if (!profile) {
        completion(@{});
        return;
    }

    NSMutableDictionary *userInfo = [NSMutableDictionary new];
    if (profile.userID) {
        userInfo[CMCammentIdentityUUID] = profile.userID;
    }

    if (profile.name) {
        userInfo[CMCammentIdentityUsername] = profile.name;
    }

    NSURL *imageUrl = [profile imageURLForPictureMode:FBSDKProfilePictureModeSquare size:CGSizeMake(270, 270)];
    if (imageUrl) {
        userInfo[CMCammentIdentityProfilePicture] = imageUrl.absoluteString;
    }

    completion(userInfo);
}

- (BOOL)checkIfValidTokenExists:(CMIdentityProvidedIdentityBlock)tokensBlock {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (!token || !token.tokenString) { return NO; }

    NSDate *fbExpirationDate = token.expirationDate;
    if ([fbExpirationDate compare:[NSDate date]] != NSOrderedDescending) { return NO; }

    [self mergeToken:token.tokenString withUserData:tokensBlock];
    return YES;
}

- (void)refreshUserIdentity:(CMIdentityProvidedIdentityBlock _Nonnull)tokensBlock forceSignin:(BOOL)forceSignin {

    // check if there is a valid facebook token
    if ([self checkIfValidTokenExists:tokensBlock]) {
        return;
    }

    // novalid fb token, but if forceSignin = NO, we don't want to continue
    if (!forceSignin) {
        tokensBlock(@{});
        return;
    }

    [self.fbsdkLoginManager logInWithReadPermissions:@[@"public_profile", @"user_friends", @"email", @"read_custom_friendlists"]
                                  fromViewController:self.viewController
                                             handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                                 NSString *fbAccessToken = result.token.tokenString;
                                                 if (!fbAccessToken) {
                                                     tokensBlock(@{});
                                                     return;
                                                 }

                                                 [self mergeToken:fbAccessToken
                                                     withUserData:tokensBlock];
                                             }];
}

- (void)mergeToken:(NSString *)token withUserData:(CMIdentityProvidedIdentityBlock)tokensBlock {
    [self getUserProfile:^(NSDictionary<NSString *, NSString *> *fbProfileData) {

        NSMutableDictionary<NSString *, id> *tokens = [NSMutableDictionary new];
        tokens[CMCammentIdentityProviderFacebook] = token;
        [tokens addEntriesFromDictionary:fbProfileData];

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
