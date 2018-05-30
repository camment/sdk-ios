//
//  CMGroupsListCMGroupsListNode.h
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMInviteFriendsGroupInfoNode.h"

@class CMCreateGroupButton;

@protocol CMGroupListNodeDelegate<CMInviteFriendsGroupInfoNodeDelegate, ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout>

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node;
- (void)groupInfoDidPressCreateGroupButton;

@end


@interface CMGroupsListNode: ASDisplayNode

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) CMCreateGroupButton *createNewGroupButton;
@property (nonatomic, assign) BOOL showCreateGroupButton;
@property (nonatomic, weak) id<CMGroupListNodeDelegate>delegate;

@end
