//
//  CMGroupManagementCMGroupManagementInteractorInput.h
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUser;
@class CMUsersGroup;
@class CMShow;

@protocol CMGroupManagementInteractorInput <NSObject>

- (void)joinUserToGroup:(NSString *)groupId;
- (void)replyWithJoiningPermissionForUser:(CMUser *)user group:(CMUsersGroup *)group isAllowedToJoin:(BOOL)isAllowedToJoin show:(CMShow *)show;

@end
