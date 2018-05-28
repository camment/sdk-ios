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
#import "CMAPIUsergroupListItem.h"

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

        NSArray<CMAPIUsergroupListItem *> *apiGroups = t.result.items;
        NSArray *groups = [[apiGroups rac_sequence] map:^id(CMAPIUsergroupListItem *data) {
            return [[[[CMUsersGroupBuilder new]
                    withUuid:data.groupUuid]
                      withTimestamp:data.timestamp] build];
        }].array;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.output didFetchUserGroups:groups];
        });
        return nil;
    }];
}

@end
