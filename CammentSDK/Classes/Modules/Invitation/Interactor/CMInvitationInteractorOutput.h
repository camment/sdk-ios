//
//  CMInvitationCMInvitationInteractorOutput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMInvitationInteractorOutput <NSObject>

- (void)didInviteUsersToTheGroup:(CMUsersGroup *)group usingDeeplink:(BOOL)usedDeeplink;
- (void)didFailToInviteUsersWithError:(NSError *)error;

@end