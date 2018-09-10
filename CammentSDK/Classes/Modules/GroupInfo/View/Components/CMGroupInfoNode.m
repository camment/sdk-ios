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
#import "UIFont+CammentFonts.h"
#import "CMUsersGroup.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStore.h"

@interface CMGroupInfoNode ()

@property (nonatomic, strong) ASCollectionNode *collectionNode;
@property (nonatomic, strong) CMInviteFriendsButton *inviteFriendsButton;
@property (nonatomic, strong) ASDisplayNode *headerNode;
@property (nonatomic, strong) ASTextNode *headerTextNode;
@property (nonatomic, strong) ASButtonNode *headerBackButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation CMGroupInfoNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.collectionNode = [[ASCollectionNode alloc] initWithLayoutDelegate:[CMGroupInfoCollectionViewDelegate new]
                                                             layoutFacilitator:nil];
        self.inviteFriendsButton = [CMInviteFriendsButton new];
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

        self.headerTextNode = [ASTextNode new];

        [[[RACObserve([CMStore instance], isFetchingGroupUsers) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread] subscribeNext:^(NSNumber *isFetchingGroupUsers) {
            if (isFetchingGroupUsers.boolValue) {
                [self.refreshControl beginRefreshing];
            } else {
                [self.refreshControl endRefreshing];
            }
        }];

        self.backgroundColor = [UIColor clearColor];
        self.automaticallyManagesSubnodes = YES;

    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(handleRefreshAction) forControlEvents:UIControlEventValueChanged];
    self.collectionNode.view.alwaysBounceVertical = YES;
    [self.collectionNode.view addSubview:self.refreshControl];
}

- (void)handleRefreshAction {
    if ([self.delegate respondsToSelector:@selector(groupInfoDidHandleRefreshAction:)]) {
        [self.delegate groupInfoDidHandleRefreshAction:self.refreshControl];
    }
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
    self.headerNode.style.height = ASDimensionMake(44.0f + self.calculatedSafeAreaInsets.top);
    self.inviteFriendsButton.style.height = ASDimensionMake(44.0 + self.safeAreaInsets.bottom);
    self.inviteFriendsButton.contentEdgeInsets = UIEdgeInsetsMake(.0f, .0f , self.safeAreaInsets.bottom, .0f);
    ASInsetLayoutSpec *stackLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 20.0f, .0f, 20.0f)
                                                                                child:[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:_headerTextNode]];
    ASOverlayLayoutSpec *headerLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_headerNode
                                                                                     overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.calculatedSafeAreaInsets.top, 8, .0f, 24)
                                                                                                                                    child:[ASOverlayLayoutSpec overlayLayoutSpecWithChild:stackLayoutSpec

                                                                                                                                                                                                                          overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, INFINITY, INFINITY)
                                                                                                                                                                                                                                                                         child:_headerBackButton]]]];

    ASStackLayoutSpec *layoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                            spacing:.0f
                                                                     justifyContent:ASStackLayoutJustifyContentStart
                                                                         alignItems:ASStackLayoutAlignItemsStretch
                                                                           children: @[headerLayoutSpec,
                                                                                       _collectionNode,
                                                                                       _inviteFriendsButton]];
    _collectionNode.style.flexGrow = 1;
    _headerTextNode.style.flexGrow = 1;
    layoutSpec.style.flexGrow = 1;

    return layoutSpec;
}

- (void)setAlpha:(CGFloat)alpha {
    self.collectionNode.alpha = alpha;
}

- (CGFloat)alpha {
    return self.collectionNode.alpha;
}

- (void)updateWithGroup:(CMUsersGroup *)group {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    self.headerTextNode.attributedText = [[NSAttributedString alloc] initWithString: group.isPublic ? CMLocalized(@"header.text.special_guest") :CMLocalized(@"header.text.camment_chat")
                                                                         attributes:@{
                                                                                 NSFontAttributeName: [UIFont nunitoMediumWithSize:12],
                                                                                 NSForegroundColorAttributeName: UIColorFromRGB(0x9B9B9B),
                                                                                 NSParagraphStyleAttributeName: paragraphStyle
                                                                         }];
    [self setNeedsLayout];
}

- (void)endRefreshing {
    [self.refreshControl endRefreshing];
}

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    if (orientation == UIInterfaceOrientationUnknown) { return; }
    if (UIEdgeInsetsEqualToEdgeInsets(self.safeAreaInsets, UIEdgeInsetsZero)) { return; }
    
    self.calculatedSafeAreaInsets = UIEdgeInsetsMake(
                                                     self.safeAreaInsets.top,
                                                     orientation == UIInterfaceOrientationLandscapeRight ? self.safeAreaInsets.left : .0f,
                                                     self.safeAreaInsets.bottom,
                                                     orientation == UIInterfaceOrientationLandscapeLeft? self.safeAreaInsets.right : .0f);
    
    [self.headerNode setNeedsLayout];
    [self.inviteFriendsButton setNeedsLayout];
    [self transitionLayoutWithAnimation:YES
                     shouldMeasureAsync:NO
                  measurementCompletion:nil];
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (![context isAnimated]) {
        [super animateLayoutTransition:context];
        return;
    }
    
    [UIView animateWithDuration:self.defaultLayoutTransitionDuration
                          delay:self.defaultLayoutTransitionDelay
                        options:self.defaultLayoutTransitionOptions | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.headerNode.frame = [context finalFrameForNode:self.headerNode];
                         self.collectionNode.frame = [context finalFrameForNode:self.collectionNode];
                         self.inviteFriendsButton.frame = [context finalFrameForNode:self.inviteFriendsButton];
                         self.headerTextNode.frame = [context finalFrameForNode:self.headerTextNode];
                         self.headerBackButton.frame = [context finalFrameForNode:self.headerBackButton];
                     }
                     completion:^(BOOL finished) {
                         [context completeTransition:YES];
                     }];
}

@end
