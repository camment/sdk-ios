//
//  CMInvitationCMInvitationPresenterInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol CMInvitationPresenterInput <NSObject>

- (void)setupView;
- (void)closeAction;
- (void)inviteAction;

@end