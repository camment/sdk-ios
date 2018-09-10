//
//  CMGroupInfoCMGroupInfoInteractorInput.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUser;
@class CMUsersGroup;

@protocol CMGroupInfoInteractorInput <NSObject>

- (void)fetchUsersInGroup:(NSString *)groupId;

- (void)deleteUser:(CMUser *)user fromGroup:(CMUsersGroup *)group;

- (void)blockUser:(NSString *)user group:(CMUsersGroup *)group;

- (void)unblockUser:(NSString *)user group:(CMUsersGroup *)group;

@end
