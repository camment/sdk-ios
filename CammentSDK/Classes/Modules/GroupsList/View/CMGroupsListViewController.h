//
//  CMGroupsListCMGroupsListViewController.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "CMGroupsListPresenterInput.h"
#import "CMGroupsListPresenterOutput.h"
#import "CMGroupsListNode.h"

@interface CMGroupsListViewController : ASViewController<CMGroupsListNode *><CMGroupsListPresenterOutput>

@property (nonatomic, strong) id<CMGroupsListPresenterInput, CMGroupListNodeDelegate > presenter;

@end
