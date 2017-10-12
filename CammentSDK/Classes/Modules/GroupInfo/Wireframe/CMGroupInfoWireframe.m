//
//  CMGroupInfoCMGroupInfoWireframe.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoWireframe.h"


@implementation CMGroupInfoWireframe

- (void)addToViewController:(UIViewController *)viewController {
    self.parentViewController = viewController;
    CMGroupInfoViewController *view = [CMGroupInfoViewController new];
    CMGroupInfoPresenter *presenter = [CMGroupInfoPresenter new];
    CMGroupInfoInteractor *interactor = [CMGroupInfoInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [viewController addChildViewController:view];
    [view didMoveToParentViewController:viewController];
}

- (void)presentInViewController:(UIViewController *)viewController {
    self.parentViewController = viewController;
    CMGroupInfoViewController *view = [CMGroupInfoViewController new];
    CMGroupInfoPresenter *presenter = [CMGroupInfoPresenter new];
    CMGroupInfoInteractor *interactor = [CMGroupInfoInteractor new];

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
    CMGroupInfoViewController *view = [CMGroupInfoViewController new];
    CMGroupInfoPresenter *presenter = [CMGroupInfoPresenter new];
    CMGroupInfoInteractor *interactor = [CMGroupInfoInteractor new];

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