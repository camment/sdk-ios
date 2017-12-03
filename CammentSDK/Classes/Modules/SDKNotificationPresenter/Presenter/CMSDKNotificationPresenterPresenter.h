//
//  CMSDKNotificationPresenterCMSDKNotificationPresenterPresenter.h
//  Pods
//
//  Created by Alexander Fedosov on 21/11/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMSDKNotificationPresenterPresenterInput.h"
#import "CMSDKNotificationPresenterPresenterOutput.h"
#import "CMSDKNotificationPresenterInteractorInput.h"
#import "CMSDKNotificationPresenterInteractorOutput.h"

@class CMSDKNotificationPresenterWireframe;
@protocol CMCammentSDKUIDelegate;

@interface CMSDKNotificationPresenterPresenter : NSObject<CMSDKNotificationPresenterPresenterInput, CMSDKNotificationPresenterInteractorOutput>

@property (nonatomic, weak) id<CMCammentSDKUIDelegate> output;
@property (nonatomic) id<CMSDKNotificationPresenterInteractorInput> interactor;

- (void)presentUsersAreJoiningMessage:(CMUserJoinedMessage *)message;
@end
