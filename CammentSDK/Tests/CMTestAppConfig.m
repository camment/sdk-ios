//
//  CMTestAppConfig.m
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 20.11.2017.
//

#import "CMTestAppConfig.h"

static NSString *const facebookAppID = @"272405646569362";
static NSString *const facebookAppSecret = @"02cd77cb360ba35e5f9bdfa038f091ca";
static NSString *const apiKey = @"iYeooUSdMZ8FOBMZeL2zb9YDLdW0uvbVlitykh7d";

@implementation CMTestAppConfig

- (instancetype)init{
    self = [super init];
    if (self) {
        _facebookAppId = facebookAppID;
        _facebookAppSecret = facebookAppSecret;
        self.apiKey = apiKey;
    }
    
    return self;
}

@end
