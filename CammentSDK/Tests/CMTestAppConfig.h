//
//  CMTestAppConfig.h
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 20.11.2017.
//

#import "CMAppConfig.h"

@interface CMTestAppConfig : CMAppConfig

@property (nonatomic, strong, readonly) NSString *facebookAppId;
@property (nonatomic, strong, readonly) NSString *facebookAppSecret;

@end
