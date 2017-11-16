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

- (void)signIn {
    if (!_identityProvider) {
        NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                             code:CMAuthInteractorErrorAuthProviderIsEmpty
                                         userInfo:@{}];
        [self.output authInteractorDidFailToSignIn:self withError:error];
        return;
    }

    [_identityProvider signIn:^void(NSDictionary<NSString *, id> *tokens) {

        if (tokens.allKeys.count == 0) {
            return;
        }

        NSSet *validProviders = [NSSet setWithObjects:CMCammentIdentityProviderFacebook, nil];

        NSArray *incorrectProviders = [tokens.allKeys.rac_sequence filter:^BOOL(NSString *providerKey) {
            return ![validProviders containsObject:providerKey];
        }].array;

        if (incorrectProviders.count > 0) {
            NSError *error = [NSError errorWithDomain:CMAuthInteractorErrorDomain
                                                 code:CMAuthInteractorErrorAuthProviderReturnsIncorrectParameters
                                             userInfo:@{
                                                     @"Unknown providers" : incorrectProviders,
                                             }];
            [self.output authInteractorDidFailToSignIn:self withError:error];
            return;
        }

        [CMStore instance].tokens = tokens;

        [self.output authInteractorDidSignIn:self];

        return;
    }];
}

@end
