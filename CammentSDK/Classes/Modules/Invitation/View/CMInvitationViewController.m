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
    return [super initWithNode:[CMInvitationNode new]];
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

- (void)showIsNoFriendsFound:(BOOL)isNoFriendsCount {
    self.node.isNoFriendsFound = isNoFriendsCount;
    [self.node transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

@end
