//
//  CMGroupInfoCMGroupInfoPresenter.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoPresenter.h"
#import "CMGroupInfoWireframe.h"
#import "CMStore.h"

@implementation CMGroupInfoPresenter

- (void)setupView {

}

- (void)handleLearnMoreAction {
    NSURL *infoURL = [[NSURL alloc] initWithString:@"http://camment.tv"];
    [[UIApplication sharedApplication] openURL:infoURL
                                       options:@{}
                             completionHandler:nil];
}

- (void)handleInviteFriendsAction {
    [[[CMStore instance] inviteFriendsActionSubject] sendNext:@YES];
}


@end