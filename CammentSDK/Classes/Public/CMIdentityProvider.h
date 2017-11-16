//
// Created by Alexander Fedosov on 15.11.2017.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const _Nonnull CMCammentIdentityProviderFacebook;

typedef void(^CMIdentityProviderTokensBlock)(NSDictionary<NSString *, id> * _Nonnull tokens);

@protocol CMIdentityProvider <NSObject>

- (void)signIn:(CMIdentityProviderTokensBlock _Nonnull)tokensBlock;
- (void)signOut;

@end
