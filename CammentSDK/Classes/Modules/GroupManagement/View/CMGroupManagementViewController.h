//
//  CMGroupManagementCMGroupManagementViewController.h
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "CMGroupManagementPresenterInput.h"
#import "CMGroupManagementPresenterOutput.h"
#import "CMGroupManagementNode.h"

@interface CMGroupManagementViewController : ASViewController<CMGroupManagementNode *><CMGroupManagementPresenterOutput>

@property (nonatomic, strong) id<CMGroupManagementPresenterInput> presenter;

@end
