//
//  CMLoginCMLoginInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMAuthInteractor.h"
#import "CMAWSServicesFactory.h"

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

- (AWSTask *)refreshIdentity:(BOOL)forceSignIn {
    if (!_identityProvider) {
        NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                             code:CMAuthInteractorErrorAuthProviderIsEmpty
                                         userInfo:@{}];
        return [AWSTask taskWithError:error];
    }

    AWSTaskCompletionSource *taskCompletionSource = [AWSTaskCompletionSource taskCompletionSource];

    [_identityProvider refreshUserIdentity:^void(NSDictionary<NSString *, id> *tokens) {

        if (tokens.allKeys.count == 0) {
            [taskCompletionSource setResult:tokens];
            return;
        }

        NSSet *validProviders = [NSSet setWithObjects:
                CMCammentIdentityProviderFacebook,
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
            [taskCompletionSource setError:error];
            return;
        }

        NSString *fbToken = tokens[CMCammentIdentityProviderFacebook];

        if (!fbToken || fbToken.length == 0) {
            NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                                 code:CMAuthInteractorErrorAuthProviderReturnsIncorrectParameters
                                             userInfo:@{}];
            [taskCompletionSource setError:error];
            return;
        }

        [taskCompletionSource setResult:tokens];

        return;
    }                          forceSignin:forceSignIn];

    return taskCompletionSource.task;
}

- (void)logOut {
    [self.identityProvider logOut];
}

@end
