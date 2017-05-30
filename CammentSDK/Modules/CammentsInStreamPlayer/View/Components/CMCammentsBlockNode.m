//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockNode.h"
#import "CMLeftAlignedLayout.h"


@interface CMCammentsBlockNode ()
@property(nonatomic, strong) UICollectionViewFlowLayout* flowLayout;
@end

@implementation CMCammentsBlockNode

- (instancetype)init {
    self = [super init];

    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.flowLayout = [CMLeftAlignedLayout new];
        self.collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout: self.flowLayout];
        self.collectionNode.backgroundColor = [UIColor clearColor];
        self.flowLayout.minimumInteritemSpacing = 400.f;
        self.flowLayout.minimumLineSpacing = 4.f;
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.collectionNode.collectionViewLayout = self.flowLayout;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    [self.collectionNode.view setShowsVerticalScrollIndicator: NO];
    [self.collectionNode.view setAlwaysBounceVertical: YES];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f)
                                                  child:_collectionNode];
}

- (void)setDelegate:(id <CMCammentsBlockDelegate>)delegate {
    self.collectionNode.dataSource = delegate;
    self.collectionNode.delegate = delegate;
    //self.collectionNode.view.asyncDelegate = delegate;
}


@end
