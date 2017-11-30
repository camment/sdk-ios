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
#import "CMShow.h"
#import "CMStore.h"
#import "CMUsersGroupBuilder.h"
#import "CMAnalytics.h"
#import "CMAuthStatusChangedEventContext.h"

@interface CMGroupManagementInteractor()

@property (nonatomic, strong) CMStore *store;

@end

@implementation CMGroupManagementInteractor

- (instancetype)initWithOutput:(id <CMGroupManagementInteractorOutput>)output store:(CMStore *)store {
    self = [super init];
    if (self) {
        self.output = output;
        self.store = store;
    }

    return self;
}

+ (instancetype)interactorWithOutput:(id <CMGroupManagementInteractorOutput>)output store:(CMStore *)store {
    return [[self alloc] initWithOutput:output store:store];
}


- (void)joinUserToGroup:(CMUsersGroup *)group {
    DDLogInfo(@"Join group id %@", group);

    if (![group.uuid isEqualToString:self.store.activeGroup.uuid]) {
        [self.store setActiveGroup:group];
        [[self.store reloadActiveGroupSubject] sendNext:@YES];
        [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventJoinGroup];
    } else {
        [[CMStore instance].userHasJoinedSignal sendNext:@YES];
    }
}


- (void)replyWithJoiningPermissionForUser:(CMUser *)user group:(CMUsersGroup *)group isAllowedToJoin:(BOOL)isAllowedToJoin show:(CMShow *)show {
    CMAPIDevcammentClient *client = [CMAPIDevcammentClient defaultAPIClient];
    if (isAllowedToJoin) {
        [[client usergroupsGroupUuidUsersUserIdPut:user.cognitoUserId groupUuid:group.uuid showUuid:show.uuid] continueWithBlock:^id(AWSTask<id> *t) {
            return nil;
        }];
    } else {
        [[client usergroupsGroupUuidUsersUserIdDelete:user.cognitoUserId groupUuid:group.uuid] continueWithBlock:^id(AWSTask<id> *t) {
            return nil;
        }];
    }
}

- (void)removeUser:(NSString *)userUuid fromGroup:(NSString *)groupUuid {
    if ([groupUuid isEqualToString:self.store.activeGroup.uuid]) {
        CMAuthStatusChangedEventContext *context = [self.store.authentificationStatusSubject first];
        if ([context.user.cognitoUserId isEqualToString:userUuid]) {
            [self.store cleanUpCurrentChatGroup];
            [[self.store reloadActiveGroupSubject] sendNext:@YES];
            [[CMAnalytics instance] trackMixpanelEvent:kAnalyticsEventRemovedFromGroup];
        } else {
            self.store.activeGroupUsers = [self.store.activeGroupUsers.rac_sequence filter:^BOOL(CMUser *value) {
                return [value.cognitoUserId isEqualToString:userUuid];
            }].array;
        }
    }
}

@end
