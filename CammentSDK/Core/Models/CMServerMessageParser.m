//
// Created by Alexander Fedosov on 06.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMServerMessageParser.h"
#import "ServerMessage.h"
#import "UserBuilder.h"
#import "UserJoinedMessageBuilder.h"
#import "CammentBuilder.h"


@implementation CMServerMessageParser {

}
- (instancetype)initWithMessageDictionary:(NSDictionary *)messageDictionary {
    self = [super init];
    if (self) {
        self.messageDictionary = messageDictionary;
    }
    return self;
}

- (ServerMessage *)parseMessage {

    NSString *type = self.messageDictionary[@"type"];
    NSDictionary *body = self.messageDictionary[@"body"];

    ServerMessage *serverMessage = nil;

    if ([type isEqualToString:@"camment"]) {
        Camment *camment = [[Camment alloc] initWithShowUuid:body[@"showUuid"]
                                               userGroupUuid:body[@"userGroupUuid"]
                                                        uuid:body[@"uuid"]
                                                   remoteURL:body[@"url"]
                                                    localURL:nil
                                                thumbnailURL:body[@"thumbnail"]
                                       userCognitoIdentityId:body[@"userCognitoIdentityId"]
                                                  localAsset:nil];
        serverMessage = [ServerMessage cammentWithCamment:camment];

    } else if ([type isEqualToString:@"invitation"]) {

        NSDictionary *userJson = body[@"invitingUser"];
        User *user = [[[[UserBuilder new] withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withUsername:userJson[@"name"]] build];

        Invitation *invitation = [[Invitation alloc] initWithUserGroupUuid:body[@"groupUuid"]
                                                           userCognitoUuid:body[@"userCognitoIdentityId"]
                                                                  showUuid:body[@"showUuid"]
                                                             invitationKey:body[@"key"]
                                                     invitedUserFacebookId:body[@"userFacebookId"]
                                                          invitationIssuer:user];
        serverMessage = [ServerMessage invitationWithInvitation:invitation];
    } else if ([type isEqualToString:@"new-user-in-group"]) {
        NSDictionary *userJson = body[@"user"];
        User *user = [[[[[[UserBuilder new] withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withFbUserId:userJson[@"facebookId"]]
                withUsername:userJson[@"name"]]
                withUserPhoto:userJson[@"picture"]] build];
        UserJoinedMessage *userJoinedMessage = [[[[UserJoinedMessageBuilder new]
                withUserGroupUuid:body[@"groupUuid"]]
                withJoinedUser:user] build];

        serverMessage = [ServerMessage userJoinedWithUserJoinedMessage:userJoinedMessage];
    }else if ([type isEqualToString:@"camment-deleted"]) {
        Camment *camment = [[Camment alloc] initWithShowUuid:body[@"showUuid"]
                                               userGroupUuid:body[@"userGroupUuid"]
                                                        uuid:body[@"uuid"]
                                                   remoteURL:body[@"url"]
                                                    localURL:nil
                                                thumbnailURL:body[@"thumbnail"]
                                       userCognitoIdentityId:body[@"userCognitoIdentityId"]
                                                  localAsset:nil];
        serverMessage = [ServerMessage cammentDeletedWithCammentDeletedMessage:[[CammentDeletedMessage alloc] initWithCamment:camment]];
    }

    return serverMessage;
}


@end