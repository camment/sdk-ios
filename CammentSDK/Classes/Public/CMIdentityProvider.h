//
// Created by Alexander Fedosov on 15.11.2017.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityProviderFacebook;

typedef void(^CMIdentityProvidedIdentityBlock)(NSDictionary<NSString *, id> * _Nonnull identity);

@protocol CMIdentityProvider <NSObject>

- (void)refreshUserIdentity:(CMIdentityProvidedIdentityBlock _Nonnull)identityBlock
                forceSignin:(BOOL)forceSignin;
- (void)logOut;

@end
