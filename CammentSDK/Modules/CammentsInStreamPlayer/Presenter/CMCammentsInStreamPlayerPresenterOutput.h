//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenterOutput.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentsBlockNode.h"

@class Show;

@protocol CMCammentsInStreamPlayerPresenterOutput <NSObject>

- (void)startShow:(Show *)show;

@end
