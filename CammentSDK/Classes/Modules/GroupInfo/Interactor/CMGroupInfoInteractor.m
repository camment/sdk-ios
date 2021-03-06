//
//  CMGroupInfoCMGroupInfoInteractor.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoInteractor.h"
#import "CMAPIDevcammentClient.h"
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

    AWSTask *task = [[CMAPIDevcammentClient defaultClient] usergroupsGroupUuidUsersGet:groupId];
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
            return [[[[[[[CMUserBuilder user]
                    withCognitoUserId:userinfo.userCognitoIdentityId]
                    withUsername:userinfo.name]
                    withUserPhoto:userinfo.picture] 
                    withBlockStatus:userinfo.state]
                    withOnlineStatus:userinfo.isOnline.boolValue ? CMUserOnlineStatus.Online : CMUserOnlineStatus.Offline]
                    build];
        }];

        [self.output groupInfoInteractor:self didFetchUsers:users inGroup:groupId];
        return nil;
    }];

}

- (void)deleteUser:(CMUser *)user fromGroup:(CMUsersGroup *)group {
    if (group.uuid.length == 0 || user.cognitoUserId.length == 0) { return; }

    AWSTask *task = [[CMAPIDevcammentClient defaultClient] usergroupsGroupUuidUsersUserIdDelete:user.cognitoUserId
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

- (void)blockUser:(NSString *)userId group:(CMUsersGroup *)group {
    if (group.uuid.length == 0 || userId.length == 0) { return; }

    CMAPIUpdateUserStateInGroupRequest *stateInGroupRequest = [[CMAPIUpdateUserStateInGroupRequest alloc] init];
    stateInGroupRequest.state = CMUserBlockStatus.Blocked;
    AWSTask *task = [[CMAPIDevcammentClient defaultClient] usergroupsGroupUuidUsersUserIdPut:userId
                                                                                      groupUuid:group.uuid
                                                                                           body:stateInGroupRequest];
    if (!task) {
        [self.output groupInfoInteractor:self didFailToBlockUser:userId group:group error:nil];
        return;
    }

    @weakify(self);
    [task continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error) {
            [self.output groupInfoInteractor:self didFailToBlockUser:userId group:group error:t.error];
            return nil;
        } else {
            [self.output groupInfoInteractor:self didBlockUser:userId group:group];
        }
        return nil;
    }];
}

- (void)unblockUser:(NSString *)userId group:(CMUsersGroup *)group {
    if (group.uuid.length == 0 || userId.length == 0) { return; }

    CMAPIUpdateUserStateInGroupRequest *stateInGroupRequest = [[CMAPIUpdateUserStateInGroupRequest alloc] init];
    stateInGroupRequest.state = CMUserBlockStatus.Active;
    AWSTask *task = [[CMAPIDevcammentClient defaultClient] usergroupsGroupUuidUsersUserIdPut:userId
                                                                                      groupUuid:group.uuid
                                                                                           body:stateInGroupRequest];
    if (!task) {
        [self.output groupInfoInteractor:self didFailToUnblockUser:userId group:group error:nil];
        return;
    }

    @weakify(self);
    [task continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error) {
            [self.output groupInfoInteractor:self didFailToUnblockUser:userId group:group error:t.error];
            return nil;
        } else {
            [self.output groupInfoInteractor:self didUnblockUser:userId group:group];
        }
        return nil;
    }];
}

- (void)setActiveGroup:(NSString *)uuid {
    CMAPIGroupUuidInRequest *groupUuidInRequest = [CMAPIGroupUuidInRequest new];
    groupUuidInRequest.groupUuid = uuid;

    AWSTask *task = [[CMAPIDevcammentClient defaultClient] meActiveGroupPost:groupUuidInRequest];
    [task continueWithBlock:^id(AWSTask<id> *t) {
        if (t.error) {
            DDLogError(@"Could not set active user group %@", t.error);
        }
        return nil;
    }];
}

- (void)unsetActiveGroup {
    AWSTask *task = [[CMAPIDevcammentClient defaultClient] meActiveGroupDelete];
    [task continueWithBlock:^id(AWSTask<id> *t) {
        if (t.error) {
            DDLogError(@"Could not unset active user group %@", t.error);
        }
        return nil;
    }];
}

@end
