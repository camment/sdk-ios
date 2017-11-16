//
//  CMLoginCMLoginInteractorInput.h
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMIdentityProvider.h"

@protocol CMAuthInteractorInput <NSObject>

- (void)signIn;

@end
