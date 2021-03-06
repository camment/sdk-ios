//
//  CMServerMessageController.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 21.11.2017.
//

#import <Foundation/Foundation.h>
#import "CMGroupManagementInteractorOutput.h"

@class CMServerMessage;
@class RACSubject;
@class CMSDKNotificationPresenter;
@protocol CMCammentSDKDelegate;
@class CMStore;
@class CMGroupManagementInteractor;

@interface CMServerMessageController : NSObject <CMGroupManagementInteractorOutput>

@property(nonatomic, weak) id <CMCammentSDKDelegate> sdkDelegate;
@property(nonatomic, strong) CMSDKNotificationPresenter *notificationPresenter;
@property(nonatomic, strong) CMStore *store;
@property(nonatomic, strong) CMGroupManagementInteractor *groupManagementInteractor;

- (instancetype)initWithSdkDelegate:(id <CMCammentSDKDelegate>)sdkDelegate notificationPresenter:(CMSDKNotificationPresenter *)notificationPresenter store:(CMStore *)store groupManagementInteractor:(CMGroupManagementInteractor *)groupManagementInteractor;

- (void)handleServerMessage:(CMServerMessage *)message;

@end
