//
//  CMGroupInfoCMGroupInfoViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoViewController.h"


@interface CMGroupInfoViewController () <CMGroupInfoNodeDelegate>
@end

@implementation CMGroupInfoViewController

- (instancetype)init {
    self = [super initWithNode:[CMGroupInfoNode new]];
    if (self) {
        self.node.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.presenter setupView];
}

- (void)notSignedNodeDidTapLearnMoreButton:(CMNotSignedInGroupInfoNode *)node {
    [self.presenter handleLearnMoreAction];
}

- (void)notSignedNodeDidTapInviteFriendsButton:(CMNotSignedInGroupInfoNode *)node {
    [self.presenter handleInviteFriendsAction];
}

@end
