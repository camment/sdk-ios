//
//  CMCammentViewCMCammentViewInteractorInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "CMCamment.h"
#import "CMUsersGroup.h"

@protocol CMCammentViewInteractorInput <NSObject>

- (void)uploadCamment:(CMCamment *)camment;

- (RACSignal<CMUsersGroup *> *)createEmptyGroup;

- (void)deleteCament:(CMCamment *)camment;
@end
