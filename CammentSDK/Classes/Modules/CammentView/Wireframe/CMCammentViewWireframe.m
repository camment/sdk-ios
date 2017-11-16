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
#import "CMShowMetadata.h"
#import "CMGroupsListWireframe.h"
#import "CMGroupInfoWireframe.h"
#import "CMAuthInteractor.h"
#import "CMIdentityProvider.h"
#import "CMInvitationInteractor.h"

@implementation CMCammentViewWireframe

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"`- init` is not a valid initializer. Use `(instancetype)initWithShowMetadata:(CMShowMetadata *)metadata \n"
                                           "                 overlayLayoutConfig:(CMCammentOverlayLayoutConfig *)overlayLayoutConfig \n"
                                           "                    identityProvider:(id <CMIdentityProvider>)identityProvider` instead."
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithShowMetadata:(CMShowMetadata *)metadata
                 overlayLayoutConfig:(CMCammentOverlayLayoutConfig *)overlayLayoutConfig
                    identityProvider:(id <CMIdentityProvider>)identityProvider {
    self = [super init];

    if (self) {
        self.metadata = metadata;
        self.overlayLayoutConfig = overlayLayoutConfig;
        self.identityProvider = identityProvider;
    }

    return self;
}

- (CMCammentViewController *)controller {
    CMCammentViewController *view = [[CMCammentViewController alloc] initWithOverlayLayoutConfig:_overlayLayoutConfig];

    CMAuthInteractor *authInteractor = [[CMAuthInteractor alloc] initWithIdentityProvider:self.identityProvider];
    CMInvitationInteractor *invitationInteractor = [[CMInvitationInteractor alloc] init];
    CMCammentsBlockPresenter *cammentsBlockPresenter = [[CMCammentsBlockPresenter alloc] init];
    CMCammentViewPresenter *presenter = [[CMCammentViewPresenter alloc] initWithShowMetadata:_metadata
                                                                              authInteractor:authInteractor
                                                                        invitationInteractor:invitationInteractor
                                                                      cammentsBlockPresenter:cammentsBlockPresenter];
    authInteractor.output = presenter;
    invitationInteractor.output = presenter;
    cammentsBlockPresenter.output = presenter;

    CMCammentViewInteractor *interactor = [CMCammentViewInteractor new];

    view.presenter = presenter;
    view.sidebarWireframe = [CMGroupInfoWireframe new];
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
