//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockNode.h"
#import "CMLeftAlignedLayout.h"
#import "CMLeftAlignedLayoutDelegate.h"
#import "CMCollectionNode.h"


@interface CMCammentsBlockNode ()
@end

@implementation CMCammentsBlockNode

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.collectionNode = [[CMCollectionNode alloc] initWithLayoutDelegate:[CMLeftAlignedLayoutDelegate new] layoutFacilitator:nil];
        self.collectionNode.backgroundColor = [UIColor clearColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    [self.collectionNode.view setShowsVerticalScrollIndicator: NO];
    [self.collectionNode.view setAlwaysBounceVertical: YES];
    [self.collectionNode.view setContentInset:UIEdgeInsetsMake(10.0f, 0.0f, .0f, .0f)];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 0.0f, .0f, .0f)
                                                  child:_collectionNode];
}

- (void)setDelegate:(id <CMCammentsBlockDelegate>)delegate {
    self.collectionNode.dataSource = delegate;
    self.collectionNode.delegate = delegate;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    return [self.collectionNode pointInside:[self convertPoint:point
                                                        toNode:self.collectionNode]
                                  withEvent:event];
}

@end
