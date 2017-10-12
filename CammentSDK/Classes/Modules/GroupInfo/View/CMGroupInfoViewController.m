//
//  CMGroupInfoCMGroupInfoViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoViewController.h"


@implementation CMGroupInfoViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupInfoNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setupView];
}

@end
