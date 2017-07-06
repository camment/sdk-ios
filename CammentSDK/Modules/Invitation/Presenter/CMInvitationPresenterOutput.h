//
//  CMInvitationCMInvitationPresenterOutput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMInvitationListDelegate;

@protocol CMInvitationPresenterOutput <NSObject>

- (void)setInvitationListDelegate:(id<CMInvitationListDelegate>)delegate;

@end