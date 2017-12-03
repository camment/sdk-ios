//
//  CMSDKNotificationPresenterCMSDKNotificationPresenterPresenter.m
//  Pods
//
//  Created by Alexander Fedosov on 21/11/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMSDKNotificationPresenterPresenter.h"
#import "CMMembershipAcceptedMessage.h"
#import "MBProgressHUD.h"
#import "CMInvitation.h"
#import "CammentSDK.h"
#import "CMMembershipRequestMessage.h"
#import "CMUserRemovedMessage.h"
#import "CMUserJoinedMessage.h"

@implementation CMSDKNotificationPresenterPresenter

- (void)showHud:(NSString *)status hideAfter:(NSUInteger)delay {
    UIWindow *window = [[UIApplication sharedApplication] delegate].window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = status;
    [hud hideAnimated:YES afterDelay:delay];
}

- (void)showToastMessage:(NSString *)message {
    [self showHud:message hideAfter:2];
}

- (void)presentUserJoinedToTheGroupAlert:(CMUserJoinedMessage *)message {
    [self showToastMessage:CMLocalized(@"You have joined the private chat!")];
}

- (void)presentInvitationToChat:(CMInvitation *)invitation onJoin:(void (^)(void))onJoin {

    NSString *username = invitation.invitationIssuer.username ?: @"Your friend";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"User invited you to a private chat"), username]
                                                                             message:CMLocalized(@"Would you like to join the conversation?")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Join")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          onJoin();
                                                      }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {}]];

    [self presentViewController:alertController];
}

- (void)presentInvitationToChatByLinkInClipboard:(NSURL *)url onJoin:(void (^)(void))onJoin {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"We found a link in your clipboard")]
                                                                             message:CMLocalized(@"Would you like to open it and join the group? It will redirect you to your web browser first.")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Join") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        onJoin();
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                      }]];

    [self presentViewController:alertController];
}

- (void)presentViewController:(UIViewController *)viewController {
    if (self.output && [self.output respondsToSelector:@selector(cammentSDKWantsPresentViewController:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.output cammentSDKWantsPresentViewController:viewController];
        });
    } else {
        DDLogError(@"CammentSDK UI delegate is nil or not implemented");
    }
}

- (void)presentLoginAlert:(NSString *)reason onLogin:(void (^)(void))onLogin onCancel:(void (^)(void))onCancel {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"Login with your Facebook account?")
                                                                             message:reason
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Login") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        onLogin();
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        onCancel();
    }]];

    [self presentViewController:alertController];
}

- (void)presentMembershipRequestAlert:(CMMembershipRequestMessage *)message
                             onAccept:(void (^)(void))onAccept
                            onDecline:(void (^)(void))onDecline
{
    CMUser *user = message.joiningUser;

    NSString *username = user.username ?: @"Your friend";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"User wants to join the group"), username]
                                                                             message:CMLocalized(@"Do you accept the join request?")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        onAccept();
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"No") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        onDecline();
    }]];

    [self presentViewController:alertController];
}

- (void)presentRemovedFromGroupAlert:(CMUserRemovedMessage *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CMLocalized(@"alert.left_group.title")
                                                                             message:CMLocalized(@"alert.left_group.description")
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Ok") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [self presentViewController:alertController];
}

- (void)presentUsersAreJoiningMessage:(CMUserJoinedMessage *)message {
    CMUser *user = message.joinedUser;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:CMLocalized(@"alert.user_joined.title"), user.username]
                                                                             message:CMLocalized(@"alert.user_joined.description")
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:CMLocalized(@"Ok")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {}]];

    [self presentViewController:alertController];
}
@end