//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractor.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentsInStreamPlayerInteractorInput.h"
#import "CMCammentsInStreamPlayerInteractorOutput.h"

@interface CMCammentsInStreamPlayerInteractor : NSObject<CMCammentsInStreamPlayerInteractorInput>

@property (nonatomic, weak) id<CMCammentsInStreamPlayerInteractorOutput> output;

@end