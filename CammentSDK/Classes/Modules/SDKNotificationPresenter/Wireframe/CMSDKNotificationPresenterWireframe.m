//
//  CMSDKNotificationPresenterCMSDKNotificationPresenterWireframe.m
//  Pods
//
//  Created by Alexander Fedosov on 21/11/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMSDKNotificationPresenterWireframe.h"


@implementation CMSDKNotificationPresenterWireframe

+ (CMSDKNotificationPresenter *)defaultPresenter {

    CMSDKNotificationPresenter *presenter = [CMSDKNotificationPresenter new];
    CMSDKNotificationPresenterInteractor *interactor = [CMSDKNotificationPresenterInteractor new];

    presenter.interactor = interactor;

    return presenter;
}


@end