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
#import "CMLoadingHUD.h"

@interface CMCammentsInStreamPlayerViewController : UIViewController <CMCammentsInStreamPlayerPresenterOutput, CMLoadingHUD>

@property (nonatomic, strong) id<CMCammentsInStreamPlayerPresenterInput> presenter;
@property(nonatomic, strong) ASDisplayNode* contentViewerNode;

@property(nonatomic) CGRect videoThumbnailFrame;

- (instancetype)initWithShow:(CMShow *)show;

@end
