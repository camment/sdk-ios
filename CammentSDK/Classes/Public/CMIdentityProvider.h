//
// Created by Alexander Fedosov on 15.11.2017.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityProviderFacebook;

FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityUUID;
FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityUsername;
FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityEmail;
FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityProfilePicture;

typedef void(^CMIdentityProvidedIdentityBlock)(NSDictionary<NSString *, id> * _Nonnull identity);

@protocol CMIdentityProvider <NSObject>

- (void)refreshUserIdentity:(CMIdentityProvidedIdentityBlock _Nonnull)identityBlock
                forceSignin:(BOOL)forceSignin;
- (void)signOut;

@end
