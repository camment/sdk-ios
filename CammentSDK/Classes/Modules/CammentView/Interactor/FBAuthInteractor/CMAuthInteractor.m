//
//  CMLoginCMLoginInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMAuthInteractor.h"
#import "CMCognitoAuthService.h"
#import "CMStore.h"
#import "CMUserBuilder.h"

NSString *const CMAuthInteractorErrorDomain = @"tv.camment.CMCammentViewInteractorErrorDomain";

@implementation CMAuthInteractor

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"`- init` is not a valid initializer. Use `- initWithIdentityProvider` instead."
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithIdentityProvider:(id <CMIdentityProvider>)identityProvider {
    self = [super init];
    if (self) {
        _identityProvider = identityProvider;
    }

    return self;
}

- (void)updateUserProfileData:(NSDictionary *)profileData {
    CMUser *currentUser = [[[[[[CMUserBuilder userFromExistingUser:[CMStore instance].currentUser]
            withUsername:profileData[CMCammentIdentityUsername]]
            withFbUserId:profileData[CMCammentIdentityUUID]]
            withUserPhoto:profileData[CMCammentIdentityProfilePicture]]
            withEmail:profileData[CMCammentIdentityEmail]]
            build];
    [[CMStore instance] setCurrentUser:currentUser];
}

- (void)signIn:(BOOL)forceSignin {
    if (!_identityProvider) {
        NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                             code:CMAuthInteractorErrorAuthProviderIsEmpty
                                         userInfo:@{}];
        [self.output authInteractorDidFailToSignIn:self withError:error];
        return;
    }

    [_identityProvider refreshUserIdentity:^void(NSDictionary<NSString *, id> *tokens) {

        if (tokens.allKeys.count == 0) {
            return;
        }

        NSSet *validProviders = [NSSet setWithObjects:
                CMCammentIdentityProviderFacebook,
                CMCammentIdentityUsername,
                CMCammentIdentityUUID,
                CMCammentIdentityProfilePicture,
                CMCammentIdentityEmail,
                        nil];

        NSArray *incorrectProviders = [tokens.allKeys.rac_sequence filter:^BOOL(NSString *providerKey) {
            return ![validProviders containsObject:providerKey];
        }].array;

        if (incorrectProviders.count > 0) {
            NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                                 code:CMAuthInteractorErrorAuthProviderReturnsIncorrectParameters
                                             userInfo:@{
                                                     @"Unknown providers or properties": incorrectProviders,
                                             }];
            [self.output authInteractorDidFailToSignIn:self withError:error];
            return;
        }

        NSString *fbToken = tokens[CMCammentIdentityProviderFacebook];

        if (!fbToken || fbToken.length == 0) {
            NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                                 code:CMAuthInteractorErrorAuthProviderReturnsIncorrectParameters
                                             userInfo:@{}];
            [self.output authInteractorDidFailToSignIn:self withError:error];
            return;
        }

        [CMStore instance].facebookAccessToken = fbToken;
        [self updateUserProfileData:tokens];
        [self.output authInteractorDidSignIn:self];

        return;
    }                          forceSignin:forceSignin];
}

@end
