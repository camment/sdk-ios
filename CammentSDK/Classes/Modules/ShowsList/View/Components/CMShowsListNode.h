//
//  CMShowsListCMShowsListNode.h
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol CMShowsListNodeDelegate<ASCollectionDelegate, ASCollectionDataSource, UICollectionViewDelegateFlowLayout>
- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node;
@end

@interface CMShowsListNode: ASDisplayNode

@property(nonatomic, strong) ASCollectionNode *listNode;
@property(nonatomic, strong) UIRefreshControl *refreshControl;

- (void)setShowsListDelegate:(id<CMShowsListNodeDelegate>)delegate;

@end
