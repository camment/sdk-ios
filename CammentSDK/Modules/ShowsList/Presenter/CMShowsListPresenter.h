//
//  CMShowsListCMShowsListPresenter.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMShowsListPresenterInput.h"
#import "CMShowsListPresenterOutput.h"
#import "CMShowsListInteractorInput.h"
#import "CMShowsListInteractorOutput.h"

@class CMShowsListWireframe;
@class CMShowsListCollectionPresenter;

@interface CMShowsListPresenter : NSObject<CMShowsListPresenterInput, CMShowsListInteractorOutput>

@property (nonatomic, weak) id<CMShowsListPresenterOutput> output;
@property (nonatomic) id<CMShowsListInteractorInput> interactor;
@property (nonatomic) CMShowsListWireframe *wireframe;

@end