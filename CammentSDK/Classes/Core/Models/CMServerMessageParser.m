//
// Created by Alexander Fedosov on 06.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMServerMessageParser.h"
#import "CMServerMessage.h"
#import "CMUserBuilder.h"
#import "CMUserJoinedMessageBuilder.h"
#import "CMCammentBuilder.h"
#import "CMUsersGroupBuilder.h"
#import "CMMembershipAcceptedMessageBuilder.h"
#import "CMCammentStatus.h"
#import "CMUserRemovedMessageBuilder.h"
#import "CMAdBannerBuilder.h"
#import "CMUserContants.h"

@implementation CMServerMessageParser {

}
- (instancetype)initWithMessageDictionary:(NSDictionary *)messageDictionary {
    self = [super init];
    if (self) {
        self.messageDictionary = messageDictionary;
    }
    return self;
}

- (CMServerMessage *)parseMessage {

    NSString *type = self.messageDictionary[@"type"];
    NSDictionary *body = self.messageDictionary[@"body"];

    if ([body isKindOfClass:[NSString class]]) {
        NSString *jsonString = (NSString *)body;
        NSError *error = nil;
        body = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingAllowFragments
                                                 error:&error];
        if (error || !body) {
            return nil;
        }
    }
    
    CMServerMessage *serverMessage = nil;

    if ([type isEqualToString:@"camment"]) {
        CMCamment *camment = [[CMCamment alloc] initWithShowUuid:body[@"showUuid"]
                                                   userGroupUuid:body[@"userGroupUuid"]
                                                            uuid:body[@"uuid"]
                                                       remoteURL:body[@"url"]
                                                        localURL:nil
                                                    thumbnailURL:body[@"thumbnail"]
                                           userCognitoIdentityId:body[@"userCognitoIdentityId"]
                                                      localAsset:nil
                                                     isMadeByBot:NO
                                                         botUuid:nil
                                                       botAction:nil
                                                       isDeleted:NO
                                                 shouldBeDeleted:NO
                                                          status:[[CMCammentStatus alloc]
                                                                  initWithDeliveryStatus:CMCammentDeliveryStatusSent
                                                                  isWatched:NO]];
        serverMessage = [CMServerMessage cammentWithCamment:camment];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *botData = [body valueForKey:@"botData"];
            if (!botData) { return; }
            
            NSDictionary *karaoke = [botData valueForKey:@"karaoke"];
            if (!karaoke) { return; }
            
            NSNumber *score = [karaoke valueForKey:@"score"];
            if (!score) { return; }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Your score"
                                                                message:score.stringValue
                                                               delegate:nil
                                                      cancelButtonTitle:@"Close"
                                                      otherButtonTitles:nil];
            [alertView show];
        });
        
    } else if ([type isEqualToString:@"new-user-in-group"]) {
        NSDictionary *userJson = body[@"joiningUser"];
        CMUser *user = [[[[[[CMUserBuilder new]
                withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withFbUserId:userJson[@"facebookId"]]
                withUsername:userJson[@"name"]]
                withUserPhoto:userJson[@"picture"]]
                build];

        CMUsersGroup *group = [[[[CMUsersGroupBuilder new]
                withUuid:body[@"groupUuid"]]
                withOwnerCognitoUserId:body[@"groupOwnerCognitoIdentityId"]]
                build];

        CMShow *show = [[CMShow alloc] initWithUuid:body[@"showUuid"]
                                                url:nil
                                          thumbnail:nil
                                           showType:[CMShowType videoWithShow:nil]
                                           startsAt:nil];

        CMUserJoinedMessage *userJoinedMessage = [[[[[CMUserJoinedMessageBuilder new]
                withUsersGroup:group]
                withShow:show]
                withJoinedUser:user] build];

        serverMessage = [CMServerMessage userJoinedWithUserJoinedMessage:userJoinedMessage];
    } else if ([type isEqualToString:@"user-removed"]) {
        NSDictionary *removedUser = body[@"removedUser"];
        CMUser *user = [[[[CMUserBuilder new]
                         withCognitoUserId:removedUser[@"userCognitoIdentityId"]]
                         withUsername:removedUser[@"name"]] build];
        CMUserRemovedMessage *userRemovedMessage = [[[[CMUserRemovedMessageBuilder new]
                withUserGroupUuid:body[@"groupUuid"]]
                withUser:user] build];

        serverMessage = [CMServerMessage userRemovedWithUserRemovedMessage:userRemovedMessage];
    } else if ([type isEqualToString:@"camment-deleted"]) {
        CMCamment *camment = [[CMCamment alloc] initWithShowUuid:body[@"showUuid"]
                                                   userGroupUuid:body[@"userGroupUuid"]
                                                            uuid:body[@"uuid"]
                                                       remoteURL:body[@"url"]
                                                        localURL:nil
                                                    thumbnailURL:body[@"thumbnail"]
                                           userCognitoIdentityId:body[@"userCognitoIdentityId"]
                                                      localAsset:nil
                                                     isMadeByBot:NO
                                                         botUuid:nil
                                                       botAction:nil
                                                       isDeleted:NO
                                                 shouldBeDeleted:NO
                                                          status:[[CMCammentStatus alloc]
                                                                            initWithDeliveryStatus:CMCammentDeliveryStatusSent
                                                                            isWatched:NO]];
        serverMessage = [CMServerMessage cammentDeletedWithCammentDeletedMessage:[[CMCammentDeletedMessage alloc] initWithCamment:camment]];
    } else if ([type isEqualToString:@"camment-delivered"]) {
        serverMessage = [CMServerMessage cammentDeliveredWithCammentDelivered:[[CMCammentDeliveredMessage alloc] initWithCammentUuid:body[@"uuid"]]];
    } else if ([type isEqualToString:@"membership-accepted"]) {
        CMShow *show = [[CMShow alloc] initWithUuid:body[@"showUuid"]
                                                url:nil
                                          thumbnail:nil
                                           showType:[CMShowType videoWithShow:nil]
                                           startsAt:nil];
        CMUsersGroup *group = [[[CMUsersGroupBuilder new] withUuid:body[@"groupUuid"]] build];
        CMMembershipAcceptedMessage *membershipAcceptedMessage = [[[[CMMembershipAcceptedMessageBuilder new]
                withGroup:group]
                withShow:show]
                build];
        serverMessage = [CMServerMessage membershipAcceptedWithMembershipAcceptedMessage:membershipAcceptedMessage];
    } else if ([type isEqualToString:@"user-blocked"]) {
        NSDictionary *userData = body[@"blockedUser"];
        CMUser *user = [[[[[CMUserBuilder new]
                withCognitoUserId:userData[@"userCognitoIdentityId"]]
                withUsername:userData[@"name"]]
                withUserPhoto:userData[@"picture"]]
                build];

        CMUserGroupStatusChangedMessage *message = [[CMUserGroupStatusChangedMessage alloc]
                initWithUserGroupUuid:body[@"groupUuid"]
                                user:user
                                state:CMUserState.Blocked];
        serverMessage = [CMServerMessage userGroupStatusChangedWithUserGroupStatusChangedMessage:message];
    } else if ([type isEqualToString:@"user-unblocked"]) {
        NSDictionary *userData = body[@"unblockedUser"];
        CMUser *user = [[[[[CMUserBuilder new]
                withCognitoUserId:userData[@"userCognitoIdentityId"]]
                withUsername:userData[@"name"]]
                withUserPhoto:userData[@"picture"]]
                build];

        CMUserGroupStatusChangedMessage *message = [[CMUserGroupStatusChangedMessage alloc]
                initWithUserGroupUuid:body[@"groupUuid"]
                                 user:user
                                state:CMUserState.Active];
        serverMessage = [CMServerMessage userGroupStatusChangedWithUserGroupStatusChangedMessage:message];
    } else if ([type isEqualToString:@"custom"]) {
        NSString *event = body[@"event"];
        NSString *groupUuid = body[@"groupUuid"];
        NSString *showUuid = body[@"showUuid"];
        NSNumber *timestamp = body[@"timestamp"];
        NSNumber *isPlaying = body[@"isPlaying"];


        CMVideoSyncEventMessage *message = [[CMVideoSyncEventMessage alloc] initWithEvent:event
                                                                                groupUUID:groupUuid
                                                                                 showUUID:showUuid
                                                                                isPlaying:isPlaying.boolValue
                                                                                timestamp:timestamp.doubleValue];
        serverMessage = [CMServerMessage videoSyncEventWithMessage:message];
    }

    return serverMessage;
}


@end
