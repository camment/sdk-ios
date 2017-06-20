//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSCognitoIdentity.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface CMCognitoAuthService: NSObject

- (instancetype)init;

- (void)configureWithProvider:(id <AWSIdentityProviderManager>)provider;

- (RACSignal *)signIn;
- (void)refreshIdentity;
- (void)signOut;

- (BOOL)isSignedIn;

@end
