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
#import "CMGroupsListPresenterInput.h"

@implementation CMGroupInfoContainerNode
@end

@interface CMGroupInfoViewController ()

@property (nonatomic, strong) CMGroupInfoNode *infoNode;
@property (nonatomic, weak) id<CMGroupsListPresenterInput> groupListPresenter;

@end

@implementation CMGroupInfoViewController

- (instancetype)init {
    self = [super initWithNode:[[CMGroupInfoContainerNode alloc] initWithMasterNode:nil]];
    if (self) {
        self.infoNode = [CMGroupInfoNode new];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CMGroupsListWireframe *groupsListWireframe = [CMGroupsListWireframe new];
    [groupsListWireframe addToViewController:self];
    groupsListWireframe.presenter.delegate = self.presenter;
    self.groupListPresenter = groupsListWireframe.presenter;
    self.node.masterNode = groupsListWireframe.view.node;
    self.node.detailsNode = self.infoNode;
    self.node.detailsNode.delegate = self.presenter;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:nil
                                 completion:^(id <UIViewControllerTransitionCoordinatorContext> context)
     {
         [self updateNodeOrientation];
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.presenter setupView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateNodeOrientation];
}

- (void)presentViewController:(UIViewController *)viewController {
    viewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)presentConfirmationDialogToLeaveTheGroup:(void (^)(void))onConfirmed {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"alert.confirm_leave_group.title")
                                                                             message:CMLocalized(@"alert.confirm_leave_group.text")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        onConfirmed();
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];

    [self presentViewController:alertController];
}

- (void)openGroupDetails:(CMUsersGroup *)group {
    [self.node.detailsNode updateWithGroup:group];
    [self.node setShowDetails:YES];
    [self.node transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
}

- (void)openGroupsListView {
    [self.groupListPresenter reloadGroupList];
    [self.node setShowDetails:NO];
    [self.node transitionLayoutWithAnimation:YES
                          shouldMeasureAsync:NO
                       measurementCompletion:nil];
}

- (void)hideLoadingIndicator {
    [self.node.detailsNode endRefreshing];
}

- (void)updateNodeOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self.node updateInterfaceOrientation:orientation];
}

@end
