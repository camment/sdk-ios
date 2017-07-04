//
//  CMInvitationCMInvitationViewController.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "CMInvitationPresenterInput.h"
#import "CMInvitationPresenterOutput.h"
#import "CMLoadingHUD.h"
#import "CMInvitationNode.h"

@interface CMInvitationViewController : ASViewController<CMInvitationNode *><CMInvitationPresenterOutput, CMLoadingHUD>

@property (nonatomic, strong) id<CMInvitationPresenterInput> presenter;

@end
