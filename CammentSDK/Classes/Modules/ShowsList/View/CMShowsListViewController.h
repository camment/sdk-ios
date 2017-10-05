//
//  CMShowsListCMShowsListViewController.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "CMShowsListPresenterInput.h"
#import "CMShowsListPresenterOutput.h"
#import "CMShowsListNode.h"
#import "CammentSDK.h"

@interface CMShowsListViewController: ASViewController<CMShowsListNode *><CMShowsListPresenterOutput, CMCammentSDKUIDelegate>

@property (nonatomic, strong) id<CMShowsListPresenterInput> presenter;

@end
