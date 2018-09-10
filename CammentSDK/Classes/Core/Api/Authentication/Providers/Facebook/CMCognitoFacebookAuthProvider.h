//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSCore/AWSIdentityProvider.h>

@class CMStore;
@class CMAPIDevcammentClient;

@interface CMCognitoFacebookAuthProvider : AWSCognitoCredentialsProviderHelper

@property(nonatomic, strong) NSString *facebookAccessToken;
@property(nonatomic, readonly) CMAPIDevcammentClient *APIClient;

- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                   useEnhancedFlow:(BOOL)useEnhancedFlow
           identityProviderManager:(id <AWSIdentityProviderManager>)identityProviderManager
                         APIClient:(CMAPIDevcammentClient *)APIClient;

@end
