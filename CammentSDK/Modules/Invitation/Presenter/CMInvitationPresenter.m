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
#import "Show.h"
#import "CMShowMetadata.h"

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
    [self.output showLoadingHUD];
    NSArray *users = [self.listPresenter.items.rac_sequence filter:^BOOL(User *user) {
        return [self.listPresenter.selectedUsersId containsObject:user.fbUserId];
    }].array;
    User *currentUser = [CMStore instance].currentUser;
    if (currentUser) {
        users = [users arrayByAddingObject:currentUser];
    }
    [self.interactor addUsers:users 
                        group:[CMStore instance].activeGroup 
                     showUuid:[CMStore instance].currentShowMetadata.uuid];
}

- (void)didInviteUsersToTheGroup:(UsersGroup *)group {
    [self.output hideLoadingHUD];
    [self.wireframe.view.navigationController dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showSuccessInvitationMessage];
        });
    }];
    [[CMStore instance] setActiveGroup:group];
}

- (void)didFailToInviteUsersWithError:(NSError *)error {
    [self.output hideLoadingHUD];
}

- (void)showSuccessInvitationMessage {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Done! We’ll let you know when your friend(s) arrive."
                                                                             message:@"In the meanwhile, lay back and enjoy the show -or maybe you could make a welcome camment to your friend(s)"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self.wireframe.parentViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}
    
@end
