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
    [task continueWithBlock:^id(AWSTask<id> *t) {
        @strongify(self);
        if (t.error || ![t.result isKindOfClass:[CMAPIUserinfoList class]]) {
            [self.output groupInfoInteractor:self didFailToFetchUsersInGroup:t.error];
            return nil;
        }

        CMAPIUserinfoList *userList = t.result;
        NSArray<CMUser *> *users = [userList.items map:^id(CMAPIUserinfo * userinfo) {
            return [[[[[CMUserBuilder user]
                    withCognitoUserId:userinfo.userCognitoIdentityId]
                    withUsername:userinfo.name]
                    withUserPhoto:userinfo.picture] build];
        }];

        [self.output groupInfoInteractor:self didFetchUsers:users inGroup:groupId];
        return nil;
    }];

}


@end
