//
//  CMCammentViewCMCammentViewInteractorInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>
#import "Camment.h"
#import "UsersGroup.h"

@protocol CMCammentViewInteractorInput <NSObject>

- (RACSignal<Camment *> *)uploadCamment:(Camment *)camment;
- (RACSignal<UsersGroup *> *)createEmptyGroup;

- (void)deleteCament:(Camment *)camment;
@end