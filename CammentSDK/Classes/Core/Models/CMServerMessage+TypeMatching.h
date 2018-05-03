//
// Created by Alexander Fedosov on 05.09.17.
//

#import <Foundation/Foundation.h>
#import "CMServerMessage.h"

@interface CMServerMessage (TypeMatching)

- (void)matchCamment:(CMServerMessageCammentMatchHandler)cammentMatchHandler;
- (void)matchUserJoined:(CMServerMessageUserJoinedMatchHandler)userJoinedMatchHandler;
- (void)matchCammentDeleted:(CMServerMessageCammentDeletedMatchHandler)cammentDeletedMatchHandler;
- (void)matchMembershipAccepted:(CMServerMessageMembershipAcceptedMatchHandler)membershipAcceptedMatchHandler;
- (void)matchUserRemoved:(CMServerMessageUserRemovedMatchHandler)userRemovedMatchHandler;
- (void)matchCammentDelivered:(CMServerMessageCammentDeliveredMatchHandler)cammentDeliveredMatchHandler;
- (void)matchAdBanner:(CMServerMessageAdMatchHandler)adMatchHandler;
- (void)matchUserGroupStateChanged:(CMServerMessageUserGroupStatusChangedMatchHandler)userGroupStateChangedHadler;
- (void)matchVideoSyncEvent:(CMServerMessageVideoSyncEventMatchHandler)videoSyncEventMatchHandler;

@end
