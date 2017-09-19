//
//  CMGroupsListCMGroupsListViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupsListViewController.h"


@implementation CMGroupsListViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupsListNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setupView];
}

@end
