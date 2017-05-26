//
//  CMShowsListCMShowsListWireframe.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListWireframe.h"


@implementation CMShowsListWireframe

- (void)presentInWindow:(UIWindow *)window; {
    CMShowsListViewController *view = [CMShowsListViewController new];
    CMShowsListPresenter *presenter = [CMShowsListPresenter new];
    CMShowsListInteractor *interactor = [CMShowsListInteractor new];

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
    CMShowsListViewController *view = [CMShowsListViewController new];
    CMShowsListPresenter *presenter = [CMShowsListPresenter new];
    CMShowsListInteractor *interactor = [CMShowsListInteractor new];

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
    CMShowsListViewController *view = [CMShowsListViewController new];
    CMShowsListPresenter *presenter = [CMShowsListPresenter new];
    CMShowsListInteractor *interactor = [CMShowsListInteractor new];

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