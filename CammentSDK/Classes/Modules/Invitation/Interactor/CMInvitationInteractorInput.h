//
//  CMInvitationCMInvitationInteractorInput.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUser;

@class CMUsersGroup;

@protocol CMInvitationInteractorInput <NSObject>

- (void)getDeeplink:(CMUsersGroup *)group showUuid:(NSString *)showUuid;

@end
