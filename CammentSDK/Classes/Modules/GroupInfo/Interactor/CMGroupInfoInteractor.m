//
//  CMGroupInfoCMGroupInfoInteractor.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoInteractor.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "NSArray+RacSequence.h"
#import "CMUserBuilder.h"
#import "CMUsersGroup.h"
#import "CMUser.h"
#import "CMUserContants.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <AWSCore/AWSTask.h>

@implementation CMGroupInfoInteractor

- (void)fetchUsersInGroup:(NSString *)groupId {
    if (groupId.length == 0) { return; }

    AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidUsersGet:groupId];
    if (!task) {
        [self.output groupInfoInteractor:self didFailToFetchUsersInGroup:[NSError new]];
        return;
    }

    @weakify(self);
    [task continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error || ![t.result isKindOfClass:[CMAPIUserinfoList class]]) {
            [self.output groupInfoInteractor:self didFailToFetchUsersInGroup:t.error];
            return nil;
        }

        CMAPIUserinfoList *userList = t.result;
        NSArray<CMUser *> *users = [userList.items map:^id(CMAPIUserinfo * userinfo) {
            return [[[[[[CMUserBuilder user]
                    withCognitoUserId:userinfo.userCognitoIdentityId]
                    withUsername:userinfo.name]
                    withUserPhoto:userinfo.picture] 
                    withBlockStatus:userinfo.state] build];
        }];

        [self.output groupInfoInteractor:self didFetchUsers:users inGroup:groupId];
        return nil;
    }];

}

- (void)deleteUser:(CMUser *)user fromGroup:(CMUsersGroup *)group {
    if (group.uuid.length == 0 || user.cognitoUserId.length == 0) { return; }

    AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidUsersUserIdDelete:user.cognitoUserId
                                                                                         groupUuid:group.uuid];
    if (!task) {
        [self.output groupInfoInteractor:self didFailToDeleteUser:user fromGroup:group error:nil];
        return;
    }

    @weakify(self);
    [task continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error) {
            [self.output groupInfoInteractor:self didFailToDeleteUser:user fromGroup:group error:t.error];
            return nil;
        } else {
            [self.output groupInfoInteractor:self didDeleteUser:user fromGroup:group];
        }
        return nil;
    }];
}

- (void)blockUser:(CMUser *)user group:(CMUsersGroup *)group {
    if (group.uuid.length == 0 || user.cognitoUserId.length == 0) { return; }

    CMAPIUpdateUserStateInGroupRequest *stateInGroupRequest = [[CMAPIUpdateUserStateInGroupRequest alloc] init];
    stateInGroupRequest.state = CMUserBlockStatus.Blocked;
    AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidUsersUserIdPut:user.cognitoUserId
                                                                                      groupUuid:group.uuid
                                                                                           body:stateInGroupRequest];
    if (!task) {
        [self.output groupInfoInteractor:self didFailToBlockUser:user group:group error:nil];
        return;
    }

    @weakify(self);
    [task continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error) {
            [self.output groupInfoInteractor:self didFailToBlockUser:user group:group error:t.error];
            return nil;
        } else {
            [self.output groupInfoInteractor:self didBlockUser:user group:group];
        }
        return nil;
    }];
}

- (void)unblockUser:(CMUser *)user group:(CMUsersGroup *)group {
    if (group.uuid.length == 0 || user.cognitoUserId.length == 0) { return; }

    CMAPIUpdateUserStateInGroupRequest *stateInGroupRequest = [[CMAPIUpdateUserStateInGroupRequest alloc] init];
    stateInGroupRequest.state = CMUserBlockStatus.Active;
    AWSTask *task = [[CMAPIDevcammentClient defaultAPIClient] usergroupsGroupUuidUsersUserIdPut:user.cognitoUserId
                                                                                      groupUuid:group.uuid
                                                                                           body:stateInGroupRequest];
    if (!task) {
        [self.output groupInfoInteractor:self didFailToUnblockUser:user group:group error:nil];
        return;
    }

    @weakify(self);
    [task continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error) {
            [self.output groupInfoInteractor:self didFailToUnblockUser:user group:group error:t.error];
            return nil;
        } else {
            [self.output groupInfoInteractor:self didUnblockUser:user group:group];
        }
        return nil;
    }];
}

@end
