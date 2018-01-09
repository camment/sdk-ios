//
//  CMGroupInfoCMGroupInfoViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoViewController.h"


@interface CMGroupInfoViewController ()
@end

@implementation CMGroupInfoViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupInfoNode new]];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.node.delegate = self.presenter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter setupView];
}

- (void)presentViewController:(UIViewController *)viewController {
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
