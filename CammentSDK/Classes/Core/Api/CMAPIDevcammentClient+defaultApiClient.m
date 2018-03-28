//
//  CMAPIDevcammentClient+defaultApiClient.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 16.08.17.
//  Copyright © 2017 Camment. All rights reserved.
//

#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "CMAppConfig.h"

@implementation CMAPIDevcammentClient (defaultApiClient)


+ (instancetype)defaultAPIClient {
#ifdef DEBUG
    SEL selector = NSSelectorFromString(@"testableInstance");
    if ([CMAPIDevcammentClient respondsToSelector:selector]) {
        return [CMAPIDevcammentClient performSelector:selector];
    }
#endif
    
    return [CMAPIDevcammentClient clientForKey:CMAPIClientName];
}

@end
