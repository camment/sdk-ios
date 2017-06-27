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
#import "CMStore.h"
#import "User.h"

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
    NSArray *users = [self.listPresenter.items.rac_sequence filter:^BOOL(User *user) {
        return [self.listPresenter.selectedUsersId containsObject:user.fbUserId];
    }].array;
    [self.interactor addUsers:users group:[CMStore instance].activeGroup];
}

- (void)didInviteUsersToTheGroup:(UsersGroup *)group {
    [[CMStore instance] setActiveGroup:group];
    [self.wireframe.view.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didFailToInviteUsersWithError:(NSError *)error {

}

@end