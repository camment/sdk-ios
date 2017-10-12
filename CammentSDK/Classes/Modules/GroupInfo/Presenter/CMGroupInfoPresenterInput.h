//
//  CMGroupInfoCMGroupInfoPresenterInput.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol CMGroupInfoPresenterInput <NSObject>

- (void)setupView;
- (void)handleLearnMoreAction;
- (void)handleInviteFriendsAction;

@end