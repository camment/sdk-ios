//
//  CMInvitationCMInvitationInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMInvitationInteractor.h"
#import "AWSTask.h"
#import "CMDevcammentClient.h"
#import "UsersGroup.h"
#import "NSArray+RACSequenceAdditions.h"
#import "RACSequence.h"
#import "User.h"

@interface CMInvitationInteractor ()
@property(nonatomic, strong) CMDevcammentClient *client;
@end

@implementation CMInvitationInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.client = [CMDevcammentClient defaultClient];
    }
    return self;
}

- (AWSTask<UsersGroup *> *)createEmptyGroup {
    return [[self.client usergroupsPost] continueWithBlock:^id(AWSTask<id> *t) {
        if ([t.result isKindOfClass:[CMUsergroup class]]) {
            CMUsergroup *group = t.result;
            UsersGroup *result = [[UsersGroup alloc] initWithUuid:group.uuid
                                               ownerCognitoUserId:group.userCognitoIdentityId
                                                        timestamp:group.timestamp];
            DDLogVerbose(@"Created new group %@", result);
            return [AWSTask taskWithResult:result];
        } else {
            DDLogError(@"%@", t.error);
            return [AWSTask taskWithError:t.error];
        }
    }];
}

- (void)addUsers:(NSArray<User *> *)users group:(UsersGroup *)group {
    CMUserInAddToGroupRequest *usersParameter = [[CMUserInAddToGroupRequest alloc] init];
    usersParameter.userFacebookIdList = [users.rac_sequence map:^id(User *value) {
        return value.fbUserId;
    }].array ?: @[];

    AWSTask *groupTask = group != nil ? [AWSTask taskWithResult:group] : [self createEmptyGroup];
    if (group) {
        DDLogVerbose(@"Inviting to the current group %@", group);
    }

    [[groupTask continueWithBlock:^id(AWSTask<id> *t) {
        if ([t.result isKindOfClass:[UsersGroup class]]) {
            UsersGroup *usersGroup = t.result;
            return [[self.client usergroupsGroupUuidUsersPost:usersGroup.uuid body:usersParameter] continueWithBlock:^id(AWSTask<id> *t) {
                return [AWSTask taskWithResult:usersGroup];
            }];
        } else {
            DDLogError(@"%@", t.error);
            return [AWSTask taskWithError:t.error];
        }
    }] continueWithBlock:^id(AWSTask<id> *t) {
        if (!t.error && [t.result isKindOfClass:[UsersGroup class]]) {
            DDLogVerbose(@"Invited users %@", users);
            UsersGroup *usersGroup = t.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didInviteUsersToTheGroup:usersGroup];
            });

            CMInvitationInRequest *invitationInRequest = [CMInvitationInRequest new];
            invitationInRequest.users = usersParameter.userFacebookIdList;
            [[self.client usergroupsGroupUuidInvitationsPost:usersGroup.uuid body:invitationInRequest]
                    continueWithBlock:^id(AWSTask<id> *invitationTask) {
                        if (invitationTask.error) {
                            DDLogError(@"%@", t.error);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.output didFailToInviteUsersWithError:t.error];
                            });
                        }
                        return nil;
                    }];
        } else {
            DDLogError(@"%@", t.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didFailToInviteUsersWithError:t.error];
            });
        }

        return nil;
    }];
}

@end