//
//  CMShowsListCMShowsListViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "CMShowsListViewController.h"


@interface CMShowsListViewController () <ASCollectionDelegate>
@end

@implementation CMShowsListViewController

- (instancetype)init {
    self = [super initWithNode:[CMShowsListNode new]];
    if (self) {
        self.title = @"Shows";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setupView];
}

- (void)setLoadingIndicator {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
}

- (void)hideLoadingIndicator {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}


- (void)setCammentsBlockNodeDelegate:(id <CMShowsListNodeDelegate>)delegate {
    [self.node setShowsListDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
