//
//  CMInvitationCMInvitationViewController.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMInvitationViewController.h"


@implementation CMInvitationViewController

- (instancetype)init {
    self = [super initWithNode:[CMInvitationNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                            target:self
                                                                            action:@selector(closeAction)];
    self.navigationItem.leftBarButtonItem = closeButton;

    UIBarButtonItem *inviteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                            target:self
                                                                            action:@selector(inviteAction)];
    self.navigationItem.rightBarButtonItem = inviteButton;

    [self.presenter setupView];
}

- (void)setInvitationListDelegate:(id <CMInvitationListDelegate>)delegate {
    [self.node setInvitationListDelegate:delegate];
}

- (void)closeAction {
    [self.presenter closeAction];
}

- (void)inviteAction {
    [self.presenter inviteAction];
}

@end
