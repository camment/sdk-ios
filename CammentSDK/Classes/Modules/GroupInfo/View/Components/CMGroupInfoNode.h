//
//  CMGroupInfoCMGroupInfoNode.h
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMInviteFriendsGroupInfoNode.h"
#import "CMDisplayNode.h"

@class CMUsersGroup;

@protocol CMGroupInfoNodeDelegate<CMInviteFriendsGroupInfoNodeDelegate,ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout>

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node;
- (void)groupInfoDidHandleRefreshAction:(UIRefreshControl *)refreshControl;
- (void)groupInfoDidPressInviteButton;
- (void)groupInfoDidPressBackButton;

@end

@interface CMGroupInfoNode: CMDisplayNode

@property (nonatomic, weak) id<CMGroupInfoNodeDelegate>delegate;

- (void)updateWithGroup:(CMUsersGroup *)group;
- (void)endRefreshing;

@end
