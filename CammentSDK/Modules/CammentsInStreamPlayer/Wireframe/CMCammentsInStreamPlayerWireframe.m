//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerWireframe.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMCammentsInStreamPlayerWireframe.h"
#import "CMCammentRecorderInteractor.h"
#import "CMShow.h"


@implementation CMCammentsInStreamPlayerWireframe

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        self.show = show;
    }

    return self;
}


- (void)presentInWindow:(UIWindow *)window; {
    CMCammentsInStreamPlayerViewController *view = [CMCammentsInStreamPlayerViewController new];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];
    CMCammentsInStreamPlayerInteractor *interactor = [CMCammentsInStreamPlayerInteractor new];
    CMCammentRecorderInteractor *recorderInteractor = [CMCammentRecorderInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.recorderInteractor = recorderInteractor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;
    recorderInteractor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [window setRootViewController:view];
}

- (void)presentInViewController:(UIViewController *)viewController {
    self.parentViewController = viewController;
    CMCammentsInStreamPlayerViewController *view = [CMCammentsInStreamPlayerViewController new];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];
    CMCammentsInStreamPlayerInteractor *interactor = [CMCammentsInStreamPlayerInteractor new];
    CMCammentRecorderInteractor *recorderInteractor = [CMCammentRecorderInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.recorderInteractor = recorderInteractor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;
    recorderInteractor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [viewController presentViewController:view animated:YES completion:nil];
}

- (void)pushInNavigationController:(UINavigationController *)navigationController {
    self.parentNavigationController = navigationController;
    CMCammentsInStreamPlayerViewController *view = [CMCammentsInStreamPlayerViewController new];
    CMCammentsInStreamPlayerPresenter *presenter = [[CMCammentsInStreamPlayerPresenter alloc] initWithShow:_show];
    CMCammentsInStreamPlayerInteractor *interactor = [CMCammentsInStreamPlayerInteractor new];
    CMCammentRecorderInteractor *recorderInteractor = [CMCammentRecorderInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.recorderInteractor = recorderInteractor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;
    recorderInteractor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    [navigationController pushViewController:view animated:YES];
}

@end