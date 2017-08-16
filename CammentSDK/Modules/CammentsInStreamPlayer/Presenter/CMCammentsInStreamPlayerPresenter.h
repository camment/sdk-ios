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

@interface CMCammentsInStreamPlayerPresenter : NSObject<CMCammentsInStreamPlayerPresenterInput>

@property (nonatomic, weak) id<CMCammentsInStreamPlayerPresenterOutput> output;

@property (nonatomic) CMCammentsInStreamPlayerWireframe *wireframe;

- (instancetype)initWithShow:(CMShow *)show;
@end