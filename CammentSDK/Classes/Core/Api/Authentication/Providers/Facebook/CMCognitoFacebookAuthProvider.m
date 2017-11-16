//
// Created by Alexander Fedosov on 17.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AWSCore/AWSCore.h>
#import "CMCognitoFacebookAuthProvider.h"
#import "CMStore.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMCognitoAuthService.h"
#import "CMAppConfig.h"

@implementation CMCognitoFacebookAuthProvider

- (AWSTask<NSDictionary<NSString *, NSString *> *> *)logins {
    if ([CMStore instance].facebookAccessToken) {
        return [super logins];
    }
    return [AWSTask taskWithResult:nil];
}

- (AWSTask<NSString *> *)token {

    NSString *fbAccessToken = [CMStore instance].facebookAccessToken ?: @"";

    CMAPIDevcammentClient *client = [CMAPIDevcammentClient clientForKey:CMAnonymousAPIClientName];
    [client setAPIKey:[CMStore instance].apiKey];
    return [[client usersGetOpenIdTokenGet:fbAccessToken]
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
