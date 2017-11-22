//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractor.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentsLoaderInteractorInput.h"
#import "CMCammentsLoaderInteractorOutput.h"

@class RACSubject;

@interface CMCammentsLoaderInteractor : NSObject<CMCammentsLoaderInteractorInput>

@property (nonatomic, weak) id<CMCammentsLoaderInteractorOutput> output;

- (instancetype)initWithNewMessageSubject:(RACSubject *)serverMessageSubject;


@end
