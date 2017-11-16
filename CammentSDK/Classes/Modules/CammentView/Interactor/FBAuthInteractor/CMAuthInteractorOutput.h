//
//  CMLoginCMLoginInteractorOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMAuthInteractorInput.h"

FOUNDATION_EXPORT NSString *const CMAuthInteractorErrorDomain;

typedef NS_ENUM(NSInteger, CMAuthInteractorErrorType) {
    CMAuthInteractorErrorUnknown,
    CMAuthInteractorErrorAuthProviderIsEmpty,
    CMAuthInteractorErrorAuthProviderReturnsIncorrectParameters,
};

@protocol CMAuthInteractorOutput <NSObject>

- (void)authInteractorDidSignIn:(id <CMAuthInteractorInput>)authInteractor;
- (void)authInteractorDidFailToSignIn:(id <CMAuthInteractorInput>)authInteractor withError:(NSError *)error;

@end
