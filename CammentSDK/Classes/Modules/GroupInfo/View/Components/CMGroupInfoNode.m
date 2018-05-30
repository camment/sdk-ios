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
#import "UIColorMacros.h"

@interface CMGroupInfoNode ()

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) CMInviteFriendsButton *inviteFriendsButton;
@property (nonatomic, strong) ASDisplayNode *headerNode;
@property (nonatomic, strong) ASTextNode *headerTextNode;
@property (nonatomic, strong) ASButtonNode *headerBackButton;

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


        self.headerNode = [ASDisplayNode new];
        self.headerNode.backgroundColor = UIColorFromRGB(0xE6E6E6);

        self.headerBackButton = [ASButtonNode new];
        self.headerBackButton.style.height = ASDimensionMake(44.0f);
        self.headerBackButton.style.width = ASDimensionMake(44.0f);

        [self.headerBackButton setContentHorizontalAlignment:ASHorizontalAlignmentLeft];
        [self.headerBackButton setContentVerticalAlignment:ASVerticalAlignmentCenter];

        [self.headerBackButton setImage:[UIImage imageNamed:@"back_btn"
                                                            inBundle:[NSBundle cammentSDKBundle] compatibleWithTraitCollection:nil]
                               forState:UIControlStateNormal];
        [self.headerBackButton addTarget:self
                                  action:@selector(handlebackButtonPress)
                        forControlEvents:ASControlNodeEventTouchUpInside];
        self.headerNode.style.height = ASDimensionMake(44.0f);

        self.backgroundColor = [UIColor clearColor];
        self.automaticallyManagesSubnodes = YES;

    }

    return self;
}

- (void)handlebackButtonPress {
    [self.delegate groupInfoDidPressBackButton];
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

    ASOverlayLayoutSpec *overlayLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_headerNode
                                                                                     overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 8, .0f, 8) child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                                                                                                                                                     spacing:12.0f
                                                                                                                                                                                                              justifyContent:ASStackLayoutJustifyContentStart
                                                                                                                                                                                                                  alignItems:ASStackLayoutAlignItemsStretch
                                                                                                                                                                                                                    children:@[_headerBackButton]]]];

    ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:.0f
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStretch
                                                                           children: @[overlayLayoutSpec, _collectionNode, _inviteFriendsButton]];
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
