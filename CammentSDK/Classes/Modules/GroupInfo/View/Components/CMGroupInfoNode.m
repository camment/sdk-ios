//
//  CMGroupInfoCMGroupInfoNode.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMGroupInfoNode.h"

@interface CMGroupInfoNode ()

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end

@implementation CMGroupInfoNode

- (instancetype)init {
    self = [super init];
    if (self) {

        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.minimumInteritemSpacing = .0f;
        flowLayout.minimumLineSpacing = .0f;

        self.collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;

    }

    return self;
}

- (void)setDelegate:(id <CMGroupInfoNodeDelegate>)delegate {
    _delegate = delegate;
    _collectionNode.delegate = _delegate;
    _collectionNode.dataSource = _delegate;
    [_delegate setItemCollectionDisplayNode:_collectionNode];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
  return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                child:_collectionNode];
}

@end
