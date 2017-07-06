//
//  CMInvitationCMInvitationInteractorInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@class UsersGroup;

@protocol CMInvitationInteractorInput <NSObject>

- (void)addUsers:(NSArray<User *> *)users group:(UsersGroup *)group showUuid:(NSString *)showUuid;

@end