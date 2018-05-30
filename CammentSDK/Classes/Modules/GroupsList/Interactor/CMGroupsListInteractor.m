//
//  CMGroupsListCMGroupsListInteractor.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupsListInteractor.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"
#import "NSArray+RACSequenceAdditions.h"
#import "RACSequence.h"
#import "CMUsersGroupBuilder.h"
#import "CMUserBuilder.h"
#import "CMUserContants.h"
#import "NSArray+RacSequence.h"

@implementation CMGroupsListInteractor

- (void)fetchUserGroupsForShow:(NSString *)uuid {

    if (!uuid) {
        DDLogError(@"Show UUID can not be empty");
        return;
    }

    AWSTask * task = [[CMAPIDevcammentClient defaultAPIClient] meGroupsGet:uuid];
    if (!task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.output didFailToFetchUserGroups:nil];
        });
        return;
    }

    [task continueWithBlock:^id(AWSTask<CMAPIUsergroupList *> *t) {
        if (t.error || ![t.result isKindOfClass:[CMAPIUsergroupList class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didFailToFetchUserGroups:t.error];
            });
            return nil;
        }

        NSArray<CMAPIUsergroup *> *apiGroups = t.result.items;
        NSArray *groups = [[apiGroups rac_sequence] map:^id(CMAPIUsergroup *data) {
            return [[[[[[[[CMUsersGroupBuilder new]
                    withUuid:data.uuid]
                    withShowUuid:data.showId] withHostCognitoUserId:data.hostId]
                    withOwnerCognitoUserId:data.userCognitoIdentityId]
                    withUsers:[data.users map:^id(CMAPIUserinfo * userinfo) {
                        return [[[[[[[CMUserBuilder user]
                                withCognitoUserId:userinfo.userCognitoIdentityId]
                                withUsername:userinfo.name]
                                withUserPhoto:userinfo.picture]
                                withBlockStatus:userinfo.state]
                                withOnlineStatus:userinfo.isOnline.boolValue ? CMUserOnlineStatus.Online : CMUserOnlineStatus.Offline]
                                build];
                    }]]
                    withTimestamp:data.timestamp] build];
        }].array;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.output didFetchUserGroups:groups];
        });
        return nil;
    }];
}

@end
