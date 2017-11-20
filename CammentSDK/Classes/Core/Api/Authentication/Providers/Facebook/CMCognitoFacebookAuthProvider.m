//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSCore/AWSCore.h>
#import "CMCognitoFacebookAuthProvider.h"
#import "CMAPIDevcammentClient.h"

@implementation CMCognitoFacebookAuthProvider

- (instancetype)initWithRegionType:(AWSRegionType)regionType
                    identityPoolId:(NSString *)identityPoolId
                   useEnhancedFlow:(BOOL)useEnhancedFlow
           identityProviderManager:(id <AWSIdentityProviderManager>)identityProviderManager
                         APIClient:(CMAPIDevcammentClient *)APIClient {
    self = [super initWithRegionType:regionType
                      identityPoolId:identityPoolId
                     useEnhancedFlow:useEnhancedFlow
             identityProviderManager:identityProviderManager];
    if (self) {
        _APIClient = APIClient;
    }

    return self;
}

- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    if (_facebookAccessToken) {
        return [super logins];
    }
    
    return [AWSTask taskWithResult:nil];
}

- (AWSTask<NSString *> *)token {

    return [[_APIClient usersGetOpenIdTokenGet:_facebookAccessToken]
            continueWithBlock:^id(AWSTask<CMAPIOpenIdToken *> *task) {

                if (task.error || ![task.result isKindOfClass:[CMAPIOpenIdToken class]]) {
                    DDLogError(@"Could not exchange facebook token to openID token Error: %@. Response: ", task.error, task.result);
                    return [AWSTask taskWithResult:nil];
                }

                CMAPIOpenIdToken *token = task.result;
                self.identityId = token.identityId;
                
                return [AWSTask taskWithResult:token.token];
            }];
}


@end
