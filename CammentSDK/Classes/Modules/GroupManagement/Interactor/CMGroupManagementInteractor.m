//
//  CMGroupManagementCMGroupManagementInteractor.m
//  Pods
//
//  Created by Alexander Fedosov on 05/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupManagementInteractor.h"
#import "CMUser.h"
#import "CMUsersGroup.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@implementation CMGroupManagementInteractor

- (void)replyWithJoiningPermissionForUser:(CMUser *)user
                                    group:(CMUsersGroup *)group
                          isAllowedToJoin:(BOOL)isAllowedToJoin
{
    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    if (isAllowedToJoin) {
        [[client usergroupsGroupUuidUsersUserIdPut:user.userId groupUuid:group.uuid] continueWithBlock:^id(AWSTask<id> *t) {
            return nil;
        }];
    } else {
        [[client usergroupsGroupUuidUsersUserIdDelete:user.userId groupUuid:group.uuid] continueWithBlock:^id(AWSTask<id> *t) {
            return nil;
        }];
    }
}

@end