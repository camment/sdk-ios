//
//  CMGroupsListCMGroupsListNode.m
//  Pods
//
//  Created by Alexander Fedosov on 19/09/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "ASCollectionNode.h"
#import "ASTableNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMGroupsListNode.h"
#import "CMInviteFriendsButton.h"
#import "CMGroupInfoCollectionViewDelegate.h"
#import "UIFont+CammentFonts.h"

@interface CMGroupsListNode ()
@end

@implementation CMGroupsListNode

- (instancetype)init {
    self = [super init];
    if (self) {

        self.collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:[CMGroupInfoCollectionViewDelegate new]
                                                             layoutFacilitator:nil];

        self.createNewGroupButton = [CMCreateGroupButton new];
        self.createNewGroupButton.style.height = ASDimensionMake(44.0f);
        [self.createNewGroupButton addTarget:self
                                     action:@selector(handleInviteButtonPress) forControlEvents:ASControlNodeEventTouchUpInside];


        self.backgroundColor = [UIColor clearColor];
        self.automaticallyManagesSubnodes = YES;

    }

    return self;
}

- (void)handleInviteButtonPress {
    [self.delegate groupInfoDidPressCreateGroupButton];
}

- (void)setDelegate:(id <CMGroupListNodeDelegate>)delegate {
    _delegate = delegate;
    _collectionNode.delegate = _delegate;
    _collectionNode.dataSource = _delegate;
    [_delegate setItemCollectionDisplayNode:_collectionNode];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:.0f
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStretch
                                                                           children: _showCreateGroupButton ? @[_collectionNode, _createNewGroupButton] : @[_collectionNode]];
    _collectionNode.style.flexGrow = 1;
    layoutSpec.style.flexGrow = 1;

    return layoutSpec;
}

- (void)setAlpha:(CGFloat)alpha {
    self.collectionNode.alpha = alpha;
}

- (CGFloat)alpha {
    return self.collectionNode.alpha;
}


@end
