//
// Created by Alexander Fedosov on 15.11.2017.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMIdentityProvider.h"

@class FBSDKLoginManager;


@interface CMFacebookIdentityProvider : NSObject<CMIdentityProvider>

@property(nonatomic, strong) FBSDKLoginManager *fbsdkLoginManager;
@property(nonatomic, weak) UIViewController *viewController;

@end