//
// Created by Alexander Fedosov on 12.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMInviteFriendsGroupInfoNode;

@protocol CMInviteFriendsGroupInfoNodeDelegate<NSObject>

- (void)inviteFriendsGroupInfoNodeDidTapLearnMoreButton:(CMInviteFriendsGroupInfoNode *)node;
- (void)handleDidTapInviteFriendsButton;
- (void)handleDidTapContinueTutorialButton;

@end

@interface CMInviteFriendsGroupInfoNode : ASCellNode

@property (nonatomic, weak) id<CMInviteFriendsGroupInfoNodeDelegate> delegate;

@property(nonatomic) BOOL showContinueTutorialButton;

@end