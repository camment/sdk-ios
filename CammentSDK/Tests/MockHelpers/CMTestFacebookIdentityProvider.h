//
//  CMTestFacebookIdentityProvider.h
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 20.11.2017.
//

#import <Foundation/Foundation.h>
#import "CMIdentityProvider.h"

@interface CMTestFacebookIdentityProvider : NSObject<CMIdentityProvider>

@property NSString *facebookAccessToken;

@end
