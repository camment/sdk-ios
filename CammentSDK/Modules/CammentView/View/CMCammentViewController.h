//
//  CMCammentViewCMCammentViewViewController.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "CMCammentViewPresenterInput.h"
#import "CMCammentViewPresenterOutput.h"
#import "CMCammentViewNode.h"

@interface CMCammentViewController : ASViewController<CMCammentViewNode *><CMCammentViewPresenterOutput, CMCammentsOverlayViewNodeDelegate>

@property (nonatomic, strong) id<CMCammentViewPresenterInput> presenter;

@end
