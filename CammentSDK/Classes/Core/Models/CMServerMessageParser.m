//
// Created by Alexander Fedosov on 06.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMServerMessageParser.h"
#import "CMServerMessage.h"
#import "CMUserBuilder.h"
#import "CMUserJoinedMessageBuilder.h"
#import "CMCammentBuilder.h"


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

    CMServerMessage *serverMessage = nil;

    if ([type isEqualToString:@"camment"]) {
        CMCamment *camment = [[CMCamment alloc] initWithShowUuid:body[@"showUuid"]
                                               userGroupUuid:body[@"userGroupUuid"]
                                                        uuid:body[@"uuid"]
                                                   remoteURL:body[@"url"]
                                                    localURL:nil
                                                thumbnailURL:body[@"thumbnail"]
                                       userCognitoIdentityId:body[@"userCognitoIdentityId"]
                                                  localAsset:nil];
        serverMessage = [CMServerMessage cammentWithCamment:camment];

    } else if ([type isEqualToString:@"invitation"]) {

        NSDictionary *userJson = body[@"invitingUser"];
        CMUser *user = [[[[[CMUserBuilder new]
                withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withUsername:userJson[@"name"]]
                withStatus:CMUserStatusOnline]
                build];

        CMInvitation *invitation = [[CMInvitation alloc] initWithUserGroupUuid:body[@"groupUuid"]
                                                           userCognitoUuid:body[@"userCognitoIdentityId"]
                                                                  showUuid:body[@"showUuid"]
                                                             invitationKey:body[@"key"]
                                                     invitedUserFacebookId:body[@"userFacebookId"]
                                                          invitationIssuer:user];
        serverMessage = [CMServerMessage invitationWithInvitation:invitation];
    } else if ([type isEqualToString:@"new-user-in-group"]) {
        NSDictionary *userJson = body[@"user"];
        CMUser *user = [[[[[[CMUserBuilder new] withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withFbUserId:userJson[@"facebookId"]]
                withUsername:userJson[@"name"]]
                withUserPhoto:userJson[@"picture"]] build];
        CMUserJoinedMessage *userJoinedMessage = [[[[CMUserJoinedMessageBuilder new]
                withUserGroupUuid:body[@"groupUuid"]]
                withJoinedUser:user] build];

        serverMessage = [CMServerMessage userJoinedWithUserJoinedMessage:userJoinedMessage];
    }else if ([type isEqualToString:@"camment-deleted"]) {
        CMCamment *camment = [[CMCamment alloc] initWithShowUuid:body[@"showUuid"]
                                               userGroupUuid:body[@"userGroupUuid"]
                                                        uuid:body[@"uuid"]
                                                   remoteURL:body[@"url"]
                                                    localURL:nil
                                                thumbnailURL:body[@"thumbnail"]
                                       userCognitoIdentityId:body[@"userCognitoIdentityId"]
                                                  localAsset:nil];
        serverMessage = [CMServerMessage cammentDeletedWithCammentDeletedMessage:[[CMCammentDeletedMessage alloc] initWithCamment:camment]];
    }

    return serverMessage;
}


@end