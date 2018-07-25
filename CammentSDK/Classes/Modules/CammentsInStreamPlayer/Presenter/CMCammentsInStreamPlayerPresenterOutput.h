//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenterOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentsBlockNode.h"

@class CMShow;
@class CMABanner;

@protocol CMCammentsInStreamPlayerPresenterOutput <NSObject>

- (void)startShow:(CMShow *)show;

- (void)showPrerollBanner:(CMABanner *)banner completion:(dispatch_block_t)completion;
@end
