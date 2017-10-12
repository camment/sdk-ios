//
// Created by Alexander Fedosov on 12.10.2017.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMNotSignedInGroupInfoNode;

@protocol CMNotSignedInGroupInfoNodeDelegate<NSObject>

- (void)notSignedNodeDidTapLearnMoreButton:(CMNotSignedInGroupInfoNode *)node;
- (void)notSignedNodeDidTapInviteFriendsButton:(CMNotSignedInGroupInfoNode *)node;

@end

@interface CMNotSignedInGroupInfoNode : ASDisplayNode

@property (nonatomic, weak) id<CMNotSignedInGroupInfoNodeDelegate> delegate;

@end