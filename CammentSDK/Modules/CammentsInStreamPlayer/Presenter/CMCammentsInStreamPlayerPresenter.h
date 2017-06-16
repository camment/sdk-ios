//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenter.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentsInStreamPlayerPresenterInput.h"
#import "CMCammentsInStreamPlayerPresenterOutput.h"
#import "CMCammentsInStreamPlayerInteractorInput.h"
#import "CMCammentsInStreamPlayerInteractorOutput.h"
#import "CMCammentRecorderInteractorOutput.h"

@class CMCammentsInStreamPlayerWireframe;
@class CMCammentsBlockPresenter;
@protocol CMCammentRecorderInteractorInput;
@class CMShow;

@interface CMCammentsInStreamPlayerPresenter : NSObject<
        CMCammentsInStreamPlayerPresenterInput,
        CMCammentsInStreamPlayerInteractorOutput,
        CMCammentRecorderInteractorOutput>

@property (nonatomic, weak) id<CMCammentsInStreamPlayerPresenterOutput> output;

@property (nonatomic) id<CMCammentsInStreamPlayerInteractorInput> interactor;
@property (nonatomic) id<CMCammentRecorderInteractorInput> recorderInteractor;

@property (nonatomic) CMCammentsInStreamPlayerWireframe *wireframe;

- (instancetype)initWithShow:(Show *)show;
@end