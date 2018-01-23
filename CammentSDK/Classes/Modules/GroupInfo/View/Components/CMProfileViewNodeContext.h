//
// Created by Alexander Fedosov on 23.01.2018.
//

#import <Foundation/Foundation.h>

@protocol CMInviteFriendsGroupInfoNodeDelegate;


@interface CMProfileViewNodeContext : NSObject

@property (nonatomic, assign) BOOL shouldDisplayInviteFriendsButton;
@property (nonatomic, weak) id<CMInviteFriendsGroupInfoNodeDelegate> delegate;

@end