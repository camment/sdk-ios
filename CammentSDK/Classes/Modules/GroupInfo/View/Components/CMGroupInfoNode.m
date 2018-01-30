//
//  CMGroupInfoCMGroupInfoNode.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "AsyncDisplayKit.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMGroupInfoNode.h"
#import "CMGroupInfoCollectionViewDelegate.h"

@interface CMGroupInfoNode ()

@property (nonatomic, strong) ASCollectionNode *collectionNode;

@end

@implementation CMGroupInfoNode

- (instancetype)init {
    self = [super init];
    if (self) {

        self.collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:[CMGroupInfoCollectionViewDelegate new]
                                                             layoutFacilitator:nil];
        self.backgroundColor = [UIColor clearColor];
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

- (void)setAlpha:(CGFloat)alpha {
    self.collectionNode.alpha = alpha;
}

- (CGFloat)alpha {
    return self.collectionNode.alpha;
}

@end
