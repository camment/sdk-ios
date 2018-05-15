//
//  CMInvitationCMInvitationInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMInvitationInteractor.h"
#import "AWSTask.h"
#import "CMAPIDevcammentClient.h"
#import "CMUsersGroup.h"
#import "NSArray+RACSequenceAdditions.h"
#import "RACSequence.h"
#import "CMUser.h"
#import "CMUsersGroupBuilder.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@interface CMInvitationInteractor ()
@end

@implementation CMInvitationInteractor

- (AWSTask<CMUsersGroup *> *)createEmptyGroup {
    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    AWSTask * task = [client usergroupsPost];
    if (!task) {
        return [AWSTask taskWithError:[NSError errorWithDomain:@"tv.camment.invitationInteractor" code:0 userInfo:nil]];
    }
    
    return [task continueWithBlock:^id(AWSTask<id> *t) {
        if ([t.result isKindOfClass:[CMAPIUsergroup class]]) {
            CMAPIUsergroup *group = t.result;
            CMUsersGroup *result = [[CMUsersGroup alloc] initWithUuid:group.uuid
                                                   ownerCognitoUserId:group.userCognitoIdentityId
                                                    hostCognitoUserId:group.userCognitoIdentityId
                                                            timestamp:group.timestamp
                                                       invitationLink:nil];
            DDLogVerbose(@"Created new group %@", result);
            return [AWSTask taskWithResult:result];
        } else {
            DDLogError(@"%@", t.error);
            return [AWSTask taskWithError:t.error];
        }
    }];
}

- (void)addUsers:(NSArray<CMUser *> *)users group:(CMUsersGroup *)group showUuid:(NSString *)showUuid usingDeeplink:(BOOL)shouldUseDeeplink {

    NSArray *usersFbIds = [users.rac_sequence map:^id(CMUser *value) {
        return value.fbUserId;
    }].array ?: @[];

    AWSTask *groupTask = group != nil ? [AWSTask taskWithResult:group] : [self createEmptyGroup];
    if (group) {
        DDLogVerbose(@"Inviting to the current group %@", group);
    }

    [[groupTask continueWithBlock:^id(AWSTask<id> *t) {
        if ([t.result isKindOfClass:[CMUsersGroup class]]) {
            CMUsersGroup *usersGroup = t.result;

//            CMAPIUserFacebookIdListInRequest *userFacebookIdListInRequest = [CMAPIUserFacebookIdListInRequest new];
//            userFacebookIdListInRequest.showUuid = showUuid;
//            userFacebookIdListInRequest.userFacebookIdList = usersFbIds;

            AWSTask *invitationTask = nil;

//            if (shouldUseDeeplink) {
//
//                invitationTask = [[self.client usergroupsGroupUuidDeeplinkPost:usersGroup.uuid
//                                                                          body:userFacebookIdListInRequest]
//                        continueWithBlock:^id(AWSTask<CMAPIDeeplink *> *deepLinkResult) {
//                            CMUsersGroupBuilder *usersGroupBuilder = [CMUsersGroupBuilder usersGroupFromExistingUsersGroup:usersGroup];
//                            CMUsersGroup *updatedUsersGroup = usersGroup;
//                            if ([deepLinkResult.result isKindOfClass:[CMAPIDeeplink class]]) {
//                                updatedUsersGroup = [[usersGroupBuilder withInvitationLink:deepLinkResult.result.url] build];
//                            }
//                            return [AWSTask taskWithResult:updatedUsersGroup];
//                        }];
//            } else {
//                invitationTask = [[self.client usergroupsGroupUuidUsersPost:usersGroup.uuid
//                                                                       body:userFacebookIdListInRequest]
//                        continueWithBlock:^id(AWSTask<id> *task) {
//                            return [AWSTask taskWithResult:usersGroup];
//                        }];
//            }

            return invitationTask;
        } else {
            DDLogError(@"%@", t.error);
            return [AWSTask taskWithError:t.error];
        }
    }] continueWithBlock:^id(AWSTask<id> *t) {
        if (!t.error && [t.result isKindOfClass:[CMUsersGroup class]]) {
            DDLogVerbose(@"Invited users %@", users);
            CMUsersGroup *usersGroup = t.result;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didInviteUsersToTheGroup:usersGroup usingDeeplink:shouldUseDeeplink];
            });
        } else {
            DDLogError(@"%@", t.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didFailToInviteUsersWithError:t.error];
            });
        }

        return nil;
    }];
}

- (void)getDeeplink:(CMUsersGroup *)group showUuid:(NSString *)showUuid {
    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    
    AWSTask *groupTask = group != nil ? [AWSTask taskWithResult:group] : [self createEmptyGroup];

    [groupTask continueWithBlock:^id(AWSTask<id> *t) {
        if (t.error || ![t.result isKindOfClass:[CMUsersGroup class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didFailToGetInvitationLink:t.error];
            });
            return nil;
        }
        CMUsersGroup *usersGroup = t.result;

        CMAPIShowUuid *cmapiShowUuid = [CMAPIShowUuid new];
        cmapiShowUuid.showUuid = showUuid;
        AWSTask *getDeeplinkTask = [client usergroupsGroupUuidDeeplinkPost:usersGroup.uuid body:cmapiShowUuid];
        if (!getDeeplinkTask) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didFailToGetInvitationLink:nil];
            });
            return nil;
        }
        
        return [getDeeplinkTask continueWithBlock:^id(AWSTask<id> *t) {

            if (t.error || ![t.result isKindOfClass:[CMAPIDeeplink class]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.output didFailToGetInvitationLink:t.error];
                });
                return nil;
            }

            CMAPIDeeplink *deepLinkResult = t.result;

            CMUsersGroupBuilder *usersGroupBuilder = [CMUsersGroupBuilder usersGroupFromExistingUsersGroup:usersGroup];
            CMUsersGroup *updatedUsersGroup = [[usersGroupBuilder withInvitationLink:deepLinkResult.url] build];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output didInviteUsersToTheGroup:updatedUsersGroup usingDeeplink:true];
            });
            return nil;
        }];
    }];
}

@end
