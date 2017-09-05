//
//  CMGroupManagementCMGroupManagementWireframe.m
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupManagementWireframe.h"


@implementation CMGroupManagementWireframe

- (void)presentInWindow:(UIWindow *)window; {
    CMGroupManagementViewController *view = [CMGroupManagementViewController new];
    CMGroupManagementPresenter *presenter = [CMGroupManagementPresenter new];
    CMGroupManagementInteractor *interactor = [CMGroupManagementInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [window setRootViewController:view];
}

- (void)presentInViewController:(UIViewController *)viewController {
    self.parentViewController = viewController;
    CMGroupManagementViewController *view = [CMGroupManagementViewController new];
    CMGroupManagementPresenter *presenter = [CMGroupManagementPresenter new];
    CMGroupManagementInteractor *interactor = [CMGroupManagementInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [viewController presentViewController:view animated:YES completion:nil];
}

- (void)pushInNavigationController:(UINavigationController *)navigationController {
    self.parentNavigationController = navigationController;
    CMGroupManagementViewController *view = [CMGroupManagementViewController new];
    CMGroupManagementPresenter *presenter = [CMGroupManagementPresenter new];
    CMGroupManagementInteractor *interactor = [CMGroupManagementInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [navigationController pushViewController:view animated:YES];
}

@end