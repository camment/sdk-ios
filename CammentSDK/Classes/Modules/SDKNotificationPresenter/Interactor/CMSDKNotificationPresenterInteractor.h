//
//  CMSDKNotificationPresenterCMSDKNotificationPresenterInteractor.h
//  Pods
//
//  Created by Alexander Fedosov on 21/11/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMSDKNotificationPresenterInteractorInput.h"
#import "CMSDKNotificationPresenterInteractorOutput.h"

@interface CMSDKNotificationPresenterInteractor : NSObject<CMSDKNotificationPresenterInteractorInput>

@property (nonatomic, weak) id<CMSDKNotificationPresenterInteractorOutput> output;

@end