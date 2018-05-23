//
//  CMGroupInfoCMGroupInfoViewController.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMContainerNode.h"
#import "CMGroupInfoViewController.h"
#import "CMGroupsListWireframe.h"
#import "CMContainerNode.h"

@implementation CMGroupInfoContainerNode
@end

@interface CMGroupInfoViewController ()
@end

@implementation CMGroupInfoViewController

- (instancetype)init {
    self = [super initWithNode:[[CMGroupInfoContainerNode alloc] initWithMasterNode:nil]];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    CMGroupsListWireframe *groupsListWireframe = [CMGroupsListWireframe new];
    [groupsListWireframe addToViewController:self];
    self.node.masterNode = groupsListWireframe.view.node;
    self.node.detailsNode = [CMGroupInfoNode new];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.node.detailsNode.delegate = self.presenter;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter setupView];
}

- (void)presentViewController:(UIViewController *)viewController {
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)presentConfirmationDialogToLeaveTheGroup:(void (^)())onConfirmed {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"alert.confirm_leave_group.title")
                                                                             message:CMLocalized(@"alert.confirm_leave_group.text")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        onConfirmed();
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];

    [self presentViewController:alertController];
}

- (void)hideInviteButton {
    self.node.detailsNode.showInviteFriendsButton = NO;
    [self.node.detailsNode transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
}

- (void)showInviteButton {
    self.node.detailsNode.showInviteFriendsButton = YES;
    [self.node.detailsNode transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
}


@end
