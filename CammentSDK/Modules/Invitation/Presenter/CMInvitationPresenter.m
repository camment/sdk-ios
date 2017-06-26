//
//  CMInvitationCMInvitationPresenter.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMInvitationPresenter.h"
#import "CMInvitationWireframe.h"
#import "CMInvitationListPresenter.h"
#import "CMDevcammentClient.h"

@interface CMInvitationPresenter ()
@property(nonatomic, strong) CMInvitationListPresenter *listPresenter;
@end

@implementation CMInvitationPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.listPresenter = [CMInvitationListPresenter new];
    }
    return self;
}

- (void)setupView {
    self.listPresenter.interactor = self.fbFetchFriendsInteractor;
    [self.output setInvitationListDelegate:self.listPresenter];
}

- (void)closeAction {
    [self.wireframe.view.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteAction {
    NSArray<NSString *> *ids = self.listPresenter.selectedUsersId;
    CMUserInAddToGroupRequest *users = [[CMUserInAddToGroupRequest alloc] init];
//    [[CMDevcammentClient defaultClient] in]
    [self.wireframe.view.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end