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

@class CMCammentViewWireframe;
@class CMShow;
@class CMShowMetadata;

@interface CMCammentViewPresenter : NSObject<
        CMCammentViewPresenterInput,
        CMCammentViewInteractorOutput,
        CMCammentsLoaderInteractorOutput,
        CMCammentRecorderInteractorOutput>

@property (nonatomic, weak) id<CMCammentViewPresenterOutput, CMLoadingHUD> output;
@property (nonatomic) id<CMCammentViewInteractorInput> interactor;
@property (nonatomic) CMCammentViewWireframe *wireframe;

@property (nonatomic) id<CMCammentsLoaderInteractorInput> loaderInteractor;
@property (nonatomic) id<CMCammentRecorderInteractorInput> recorderInteractor;

- (instancetype)initWithShowMetadata:(CMShowMetadata *)metadata;
@end
