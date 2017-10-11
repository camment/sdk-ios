//
// Created by Alexander Fedosov on 06.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMServerMessageParser.h"
#import "CMServerMessage.h"
#import "CMUserBuilder.h"
#import "CMUserJoinedMessageBuilder.h"
#import "CMCammentBuilder.h"
#import "CMMembershipRequestMessageBuilder.h"
#import "CMUsersGroupBuilder.h"
#import "CMMembershipAcceptedMessageBuilder.h"


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
                                                      localAsset:nil
                                                     isMadeByBot:NO
                                                         botUuid:nil
                                                       botAction:nil];
        serverMessage = [CMServerMessage cammentWithCamment:camment];

    } else if ([type isEqualToString:@"invitation"]) {

        NSDictionary *userJson = body[@"invitingUser"];
        CMUser *user = [[[[[[CMUserBuilder new]
                withUserId:userJson[@"userCognitoIdentityId"]]
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
        CMUser *user = [[[[[[[CMUserBuilder new]
                withUserId:userJson[@"userCognitoIdentityId"]]
                withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withFbUserId:userJson[@"facebookId"]]
                withUsername:userJson[@"name"]]
                withUserPhoto:userJson[@"picture"]] build];
        CMUserJoinedMessage *userJoinedMessage = [[[[CMUserJoinedMessageBuilder new]
                withUserGroupUuid:body[@"groupUuid"]]
                withJoinedUser:user] build];

        serverMessage = [CMServerMessage userJoinedWithUserJoinedMessage:userJoinedMessage];
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
                                                       botAction:nil];
        serverMessage = [CMServerMessage cammentDeletedWithCammentDeletedMessage:[[CMCammentDeletedMessage alloc] initWithCamment:camment]];
    } else if ([type isEqualToString:@"membership-request"]) {
        NSDictionary *userJson = body[@"joiningUser"];
        CMUser *user = [[[[[[[CMUserBuilder new]
                withUserId:userJson[@"userCognitoIdentityId"]]
                withCognitoUserId:userJson[@"userCognitoIdentityId"]]
                withFbUserId:userJson[@"facebookId"]]
                withUsername:userJson[@"name"]]
                withUserPhoto:userJson[@"picture"]] build];
        CMShow *show = [[CMShow alloc] initWithUuid:body[@"showUuid"]
                                                url:nil
                                          thumbnail:nil
                                           showType:[CMShowType videoWithShow:nil]
                                           startsAt:nil];
        CMUsersGroup *group = [[[CMUsersGroupBuilder new] withUuid:body[@"groupUuid"]] build];
        CMMembershipRequestMessage *membershipRequestMessage = [[[[[CMMembershipRequestMessageBuilder new]
                withGroup:group]
                withShow:show]
                withJoiningUser:user]
                build];
        serverMessage = [CMServerMessage membershipRequestWithMembershipRequestMessage:membershipRequestMessage];
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
    }

    return serverMessage;
}


@end
