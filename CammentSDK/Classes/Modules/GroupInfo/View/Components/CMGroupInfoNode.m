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
#import "CMInviteFriendsButton.h"

@interface CMGroupInfoNode ()

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) CMInviteFriendsButton *inviteFriendsButton;

@end

@implementation CMGroupInfoNode

- (instancetype)init {
    self = [super init];
    if (self) {

        self.collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:[CMGroupInfoCollectionViewDelegate new]
                                                             layoutFacilitator:nil];

        self.inviteFriendsButton = [CMInviteFriendsButton new];
        self.inviteFriendsButton.style.height = ASDimensionMake(44.0f);
        [self.inviteFriendsButton addTarget:self
                                     action:@selector(handleInviteButtonPress) forControlEvents:ASControlNodeEventTouchUpInside];


        self.backgroundColor = [UIColor clearColor];
        self.automaticallyManagesSubnodes = YES;

    }

    return self;
}

- (void)handleInviteButtonPress {
    [self.delegate groupInfoDidPressInviteButton];
}

- (void)setDelegate:(id <CMGroupInfoNodeDelegate>)delegate {
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
                                                                           children: _showInviteFriendsButton ? @[_collectionNode, _inviteFriendsButton] : @[_collectionNode]];
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
