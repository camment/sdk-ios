//
//  CMLoginCMLoginInteractorOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 17/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMAuthInteractorOutput <NSObject>

- (void)authInteractorDidSignedIn;

- (void)authInteractorFailedToSignIn:(NSError *)error isCancelled:(BOOL)isCancelled;
@end