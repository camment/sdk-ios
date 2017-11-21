//
//  CMSDKNotificationPresenterCMSDKNotificationPresenterWireframe.h
//  Pods
//
//  Created by Alexander Fedosov on 21/11/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMSDKNotificationPresenterPresenter.h"
#import "CMSDKNotificationPresenterInteractor.h"

@interface CMSDKNotificationPresenterWireframe : NSObject


+ (CMSDKNotificationPresenterPresenter *)defaultPresenter;

@end