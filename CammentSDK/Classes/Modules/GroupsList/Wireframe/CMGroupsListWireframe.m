//
//  CMGroupsListCMGroupsListWireframe.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupsListWireframe.h"


@implementation CMGroupsListWireframe

- (void)presentInWindow:(UIWindow *)window; {
    CMGroupsListViewController *view = [CMGroupsListViewController new];
    CMGroupsListPresenter *presenter = [CMGroupsListPresenter new];
    CMGroupsListInteractor *interactor = [CMGroupsListInteractor new];

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
    CMGroupsListViewController *view = [CMGroupsListViewController new];
    CMGroupsListPresenter *presenter = [CMGroupsListPresenter new];
    CMGroupsListInteractor *interactor = [CMGroupsListInteractor new];

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
    CMGroupsListViewController *view = [CMGroupsListViewController new];
    CMGroupsListPresenter *presenter = [CMGroupsListPresenter new];
    CMGroupsListInteractor *interactor = [CMGroupsListInteractor new];

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