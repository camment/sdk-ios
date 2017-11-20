//
//  CMUserAuthentificationState.h
//  Pods
//
//  Created by Alexander Fedosov on 20.11.2017.
//

#ifndef CMUserAuthentificationState_h
#define CMUserAuthentificationState_h

typedef NS_ENUM(NSInteger, CMCammentUserAuthentificationState) {
    CMCammentUserNotAuthentificated,
    CMCammentUserAuthentificatedAnonymous,
    CMCammentUserAuthentificatedAsKnownUser,
};

#endif /* CMUserAuthentificationState_h */
