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

@protocol CMGroupManagementInteractorInput <NSObject>

- (void)replyWithJoiningPermissionForUser:(CMUser *)user
                                    group:(CMUsersGroup *)group
                          isAllowedToJoin:(BOOL)isAllowedToJoin;

@end