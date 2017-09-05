//
//  CMGroupManagementCMGroupManagementViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupManagementViewController.h"


@implementation CMGroupManagementViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupManagementNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setupView];
}

@end
