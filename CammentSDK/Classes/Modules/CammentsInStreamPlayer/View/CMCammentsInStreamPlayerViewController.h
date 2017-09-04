//
//  CMCammentsInStreamPlayerViewController.h
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "CMCammentsInStreamPlayerPresenterInput.h"
#import "CMCammentsInStreamPlayerPresenterOutput.h"
#import "CMCammentsInStreamPlayerNode.h"

@interface CMCammentsInStreamPlayerViewController : UIViewController <CMCammentsInStreamPlayerPresenterOutput>

@property (nonatomic, strong) id<CMCammentsInStreamPlayerPresenterInput> presenter;

@end
