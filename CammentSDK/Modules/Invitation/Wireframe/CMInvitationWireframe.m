//
//  CMInvitationCMInvitationWireframe.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMInvitationWireframe.h"
#import "CMFBFetchFriendsInteractor.h"


@implementation CMInvitationWireframe

- (void)presentInWindow:(UIWindow *)window; {
    CMInvitationViewController *view = [CMInvitationViewController new];
    CMInvitationPresenter *presenter = [CMInvitationPresenter new];
    CMInvitationInteractor *interactor = [CMInvitationInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.fbFetchFriendsInteractor = [CMFBFetchFriendsInteractor new];
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:view];
    [window setRootViewController:navigationController];
}

- (void)presentInViewController:(UIViewController *)viewController {
    self.parentViewController = viewController;
    CMInvitationViewController *view = [CMInvitationViewController new];
    CMInvitationPresenter *presenter = [CMInvitationPresenter new];
    CMInvitationInteractor *interactor = [CMInvitationInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.fbFetchFriendsInteractor = [CMFBFetchFriendsInteractor new];
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:view];

    navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    [viewController presentViewController:navigationController animated:YES completion:nil];
}

- (void)pushInNavigationController:(UINavigationController *)navigationController {
    self.parentNavigationController = navigationController;
    CMInvitationViewController *view = [CMInvitationViewController new];
    CMInvitationPresenter *presenter = [CMInvitationPresenter new];
    CMInvitationInteractor *interactor = [CMInvitationInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.fbFetchFriendsInteractor = [CMFBFetchFriendsInteractor new];
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [navigationController pushViewController:view animated:YES];
}

@end
