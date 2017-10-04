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

@class CMCammentsInStreamPlayerWireframe;
@class CMAPIShow;
@protocol CMLoadingHUD;

@interface CMCammentsInStreamPlayerPresenter : NSObject<CMCammentsInStreamPlayerPresenterInput>

@property (nonatomic, weak) id<CMCammentsInStreamPlayerPresenterOutput, CMLoadingHUD> output;

@property (nonatomic) CMCammentsInStreamPlayerWireframe *wireframe;

- (instancetype)initWithShow:(CMShow *)show;
@end