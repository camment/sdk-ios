//
//  CMShowsListCMShowsListInteractor.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMShowsListInteractorInput.h"
#import "CMShowsListInteractorOutput.h"

@interface CMShowsListInteractor : NSObject<CMShowsListInteractorInput>

@property (nonatomic, weak) id<CMShowsListInteractorOutput> output;

@end