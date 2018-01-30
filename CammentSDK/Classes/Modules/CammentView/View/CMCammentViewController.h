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

#import "UIViewController+LoadingHUD.h"
#import "CMCammentViewPresenterInput.h"
#import "CMCammentViewPresenterOutput.h"
#import "CMLoadingHUD.h"
#import "CMCammentsOverlayViewNode.h"

@class CMGroupsListWireframe;
@class CMGroupInfoWireframe;

@interface CMCammentViewController : ASViewController<CMCammentsOverlayViewNode *><CMCammentViewPresenterOutput, CMCammentsOverlayViewNodeDelegate, CMOnboardingInteractorOutput>

@property (nonatomic, strong) id<CMCammentViewPresenterInput, CMOnboardingInteractorInput> presenter;
@property (nonatomic, strong) CMGroupInfoWireframe *sidebarWireframe;

- (instancetype)initWithOverlayLayoutConfig:(CMCammentOverlayLayoutConfig *)overlayLayoutConfig NS_DESIGNATED_INITIALIZER;
@end
