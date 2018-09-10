//
//  CMGroupManagementCMGroupManagementInteractorInput.h
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMUsersGroup;
@class AWSTask;

@protocol CMGroupManagementInteractorInput <NSObject>

- (void)joinUserToGroup:(CMUsersGroup *)groupId;
- (void)removeUser:(NSString *)userUuid fromGroup:(NSString *)groupUuid;
- (AWSTask *)blockUser:(NSString *)userUuid inGroup:(NSString *)groupUuid;
- (AWSTask *)unblockUser:(NSString *)userUuid inGroup:(NSString *)groupUuid;

@end
