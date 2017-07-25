//
//  CMCammentViewCMCammentViewInteractorOutput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentViewInteractorOutput <NSObject>

- (void)interactorDidUploadCamment:(Camment *)camment;

- (void)interactorFailedToUploadCamment:(Camment *)camment error:(NSError *)error;

@end