//
//  CMCammentViewCMCammentViewWireframe.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMCammentsLoaderInteractorOutput.h"
#import "CMCammentRecorderInteractorOutput.h"
#import "CMCammentViewWireframe.h"
#import "CMCammentRecorderInteractor.h"
#import "CMCammentsLoaderInteractor.h"


@implementation CMCammentViewWireframe

- (instancetype)initWithShow:(Show *)show {
    self = [super init];
    if (self) {
        self.show = show;
    }

    return self;
}

- (CMCammentViewController *)controller {
    CMCammentViewController *view = [CMCammentViewController new];
    CMCammentViewPresenter *presenter = [[CMCammentViewPresenter alloc] initWithShow:_show];
    CMCammentViewInteractor *interactor = [CMCammentViewInteractor new];

    view.presenter = presenter;
    presenter.interactor = interactor;
    presenter.output = view;
    presenter.wireframe = self;
    interactor.output = presenter;

    CMCammentRecorderInteractor *recorderInteractor = [CMCammentRecorderInteractor new];
    CMCammentsLoaderInteractor *cammentsLoaderInteractor = [CMCammentsLoaderInteractor new];
    presenter.recorderInteractor = recorderInteractor;
    presenter.loaderInteractor = cammentsLoaderInteractor;
    recorderInteractor.output = presenter;
    cammentsLoaderInteractor.output = presenter;

    self.view = view;
    self.presenter = presenter;
    self.interactor = interactor;

    return view;
}

@end
