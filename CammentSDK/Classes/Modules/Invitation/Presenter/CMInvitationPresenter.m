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
#import "CMUser.h"
#import "CMShow.h"
#import "CMShowMetadata.h"

@interface CMInvitationPresenter ()
@property(nonatomic, strong) CMInvitationListPresenter *listPresenter;
@end

@implementation CMInvitationPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.listPresenter = [CMInvitationListPresenter new];
        [RACObserve(self.listPresenter, items) subscribeNext:^(NSArray *x) {
            [self.output showIsNoFriendsFound:[x count] == 0];
        }];
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
    NSArray *users = [self.listPresenter.items.rac_sequence filter:^BOOL(CMUser *user) {
        return [self.listPresenter.selectedUsersId containsObject:user.fbUserId];
    }].array;
//    CMUser *currentUser = [CMStore instance].currentUser;
//    if (currentUser) {
//        users = [users arrayByAddingObject:currentUser];
//    }
//    [self.interactor addUsers:users group:[CMStore instance].activeGroup showUuid:[CMStore instance].currentShowMetadata.uuid usingDeeplink:YES];
}

- (void)didInviteUsersToTheGroup:(CMUsersGroup *)group usingDeeplink:(BOOL)usedDeeplink {
    [self.output hideLoadingHUD];

    if (usedDeeplink) {
        [self.wireframe.view.navigationController dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showShareDeeplinkDialog:group.invitationLink];
            });
        }];
    } else {
        [self.wireframe.view.navigationController dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showSuccessInvitationMessage];
            });
        }];
    }

    [[CMStore instance] setActiveGroup:group];
}

- (void)showShareDeeplinkDialog:(NSString *)link {
    NSString *textToShare = @"Hey, join our private chat!";
    NSURL *url = [NSURL URLWithString:link];

    NSArray *objectsToShare = @[textToShare, url];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    [self.wireframe.parentViewController presentViewController:activityVC
                                                      animated:YES
                                                    completion:nil];
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
