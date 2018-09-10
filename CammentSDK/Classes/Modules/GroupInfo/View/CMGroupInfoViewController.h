//
//  CMGroupInfoCMGroupInfoViewController.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "CMGroupInfoPresenterInput.h"
#import "CMGroupInfoPresenterOutput.h"
#import "CMGroupInfoNode.h"
#import "CMGroupsListNode.h"
#import "CMContainerNode.h"

@interface CMGroupInfoContainerNode: CMContainerNode<CMGroupsListNode *,CMGroupInfoNode *>
@end

@interface CMGroupInfoViewController: ASViewController<CMGroupInfoContainerNode *><CMGroupInfoPresenterOutput>

@property (nonatomic, strong) id<CMGroupInfoPresenterInput> presenter;

@end
