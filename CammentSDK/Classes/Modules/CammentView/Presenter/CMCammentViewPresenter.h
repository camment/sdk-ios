//
//  CMCammentViewCMCammentViewPresenter.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentViewPresenterInput.h"
#import "CMCammentViewPresenterOutput.h"
#import "CMCammentViewInteractorInput.h"
#import "CMCammentViewInteractorOutput.h"
#import "CMCammentsLoaderInteractorInput.h"
#import "CMCammentsLoaderInteractorOutput.h"
#import "CMCammentRecorderInteractorInput.h"
#import "CMCammentRecorderInteractorOutput.h"
#import "CMLoadingHUD.h"
#import "CMCammentsBlockPresenter.h"
#import "CMInvitationInteractorOutput.h"

@class CMCammentViewWireframe;
@class CMShow;
@class CMShowMetadata;
@protocol CMInvitationInteractorInput;
@protocol CMCammentsBlockPresenterInput;
@class CMUserSessionController;
@class TBSMStateMachine;

@interface CMCammentViewPresenter : NSObject<
        CMCammentViewPresenterInput,
        CMOnboardingInteractorInput,
        CMCammentViewInteractorOutput,
        CMCammentsLoaderInteractorOutput,
        CMCammentRecorderInteractorOutput,
        CMCammentsBlockPresenterOutput,
        CMInvitationInteractorOutput>

@property (nonatomic, weak) id<CMCammentViewPresenterOutput, CMLoadingHUD, CMOnboardingInteractorOutput> output;
@property (nonatomic) id<CMCammentViewInteractorInput> interactor;
@property (nonatomic) CMCammentViewWireframe *wireframe;

@property (nonatomic) id<CMCammentsLoaderInteractorInput> loaderInteractor;
@property (nonatomic) id<CMCammentRecorderInteractorInput> recorderInteractor;
@property (nonatomic) CMUserSessionController *userSessionController;

- (instancetype)initWithShowMetadata:(CMShowMetadata *)metadata
               userSessionController:(CMUserSessionController *)userSessionController
                invitationInteractor:(id <CMInvitationInteractorInput>)invitationInteractor
              cammentsBlockPresenter:(id <CMCammentsBlockPresenterInput>)cammentsBlockPresenter NS_DESIGNATED_INITIALIZER;
@end
