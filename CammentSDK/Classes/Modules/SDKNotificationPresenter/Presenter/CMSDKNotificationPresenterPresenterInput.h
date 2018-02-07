//
//  CMSDKNotificationPresenterCMSDKNotificationPresenterPresenterInput.h
//  Pods
//
//  Created by Alexander Fedosov on 21/11/2017.
//  Copyright 2017 Camment. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol CMCammentSDKUIDelegate;
@class CMMembershipAcceptedMessage, CMMembershipRequestMessage, CMInvitation, CMUserRemovedMessage;
@class CMUserJoinedMessage;

@protocol CMSDKNotificationPresenterPresenterInput <NSObject>

@property (nonatomic, weak) id<CMCammentSDKUIDelegate> output;

- (void)showToastMessage:(NSString *)message;
- (void)presentUserJoinedToTheGroupAlert:(CMUserJoinedMessage *)message;

- (void)presentMembershipRequestAlert:(CMMembershipRequestMessage *)message onAccept:(void (^)(void))onAccept onDecline:(void (^)(void))onDecline;
- (void)presentInvitationToChat:(CMInvitation *)invitation onJoin:(void (^)(void))onJoin;
- (void)presentInvitationToChatByLinkInClipboard:(NSURL *)url onJoin:(void (^)(void))onJoin;
- (void)presentLoginAlert:(NSString *)reason onLogin:(void (^)(void))onLogin onCancel:(void (^)(void))onCancel;
- (void)presentRemovedFromGroupAlert:(CMUserRemovedMessage *)message;
- (void)presentUsersAreJoiningMessage:(CMUserJoinedMessage *)message;
- (void)presentMeBlockedInGroupDialog;
@end
