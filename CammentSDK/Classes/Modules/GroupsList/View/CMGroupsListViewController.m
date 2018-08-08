//
//  CMGroupsListCMGroupsListViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "ASCollectionNode.h"
#import "ASTableNode.h"
#import "CMGroupsListViewController.h"
#import "CMUsersGroup.h"
#import "CMGroupCellNode.h"


@interface CMGroupsListViewController ()
@end

@implementation CMGroupsListViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupsListNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.node.delegate = self.presenter;
    [self.presenter setupView];
}

- (void)hideCreateGroupButton {
    self.node.showCreateGroupButton = NO;
    [self.node transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
}

- (void)showCreateGroupButton {
    self.node.showCreateGroupButton = YES;
    [self.node transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
}

- (void)hideLoadingIndicator {
    [self.node endRefreshing];
}

@end
