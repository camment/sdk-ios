//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentsOverlayViewNode.h"
#import "CMCammentsBlockNode.h"
#import "CMCammentButton.h"
#import "CMCammentRecorderPreviewNode.h"
#import "CMCammentOverlayLayoutConfig.h"
#import "CMAdsVideoPlayerNode.h"

@interface CMCammentsOverlayViewNode ()

@property (nonatomic, assign) CGFloat cammentButtonScreenSideVerticalInset;
@property (nonatomic, strong) UIPanGestureRecognizer *cammentPanDownGestureRecognizer;

@end

@implementation CMCammentsOverlayViewNode

- (instancetype)initWithLayoutConfig:(CMCammentOverlayLayoutConfig *)layoutConfig {
    self = [super init];
    
    if (self) {
        self.layoutConfig = layoutConfig;
        self.showCammentsBlock = YES;
        _cammentsBlockNode = [CMCammentsBlockNode new];
        _leftSidebarNode = [ASDisplayNode new];
        _cammentButton = [CMCammentButton new];
        _cammentRecorderNode = [CMCammentRecorderPreviewNode new];
        _adsVideoPlayerNode = [CMAdsVideoPlayerNode new];
        _adsVideoPlayerNode.debugName = @"CMAdsVideoPlayerNode";
        
        _contentView = [UIView new];
        _contentNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            return _contentView ?: [UIView new];
        }];
        self.cammentButtonScreenSideVerticalInset = layoutConfig.cammentButtonLayoutVerticalInset;
        self.cammentPanDownGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCammentButtonPanGesture:)];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)setContentView:(UIView *)contentView {
    _contentView = contentView;

    if ([_contentView isKindOfClass:[_ASDisplayView class]]) {
        _contentNode = ASViewToDisplayNode(contentView);
    } else {
        _contentNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            return _contentView;
        }];
    }
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)setLeftSidebarNode:(ASDisplayNode *)leftSidebarNode {
    _leftSidebarNode = leftSidebarNode;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)didLoad {
    [super didLoad];
    [self.cammentButton.view addGestureRecognizer:_cammentPanDownGestureRecognizer];
}

- (ASLayoutSpec *)cammentBlockLayoutSpecThatFits:(ASSizeRange)constrainedSize {
    _cammentsBlockNode.style.width = ASDimensionMake(120.0f);

    CGFloat cammentRecorderNodeWidth = [_cammentRecorderNode layoutThatFits:ASSizeRangeMake(CGSizeMake(104, 90))].size.width;
    CGFloat cammentRecorderNodeHeight = [_cammentRecorderNode layoutThatFits:ASSizeRangeMake(CGSizeMake(104, 90))].size.height;
    _cammentRecorderNode.style.width = ASDimensionMake(_showCammentRecorderNode ? cammentRecorderNodeWidth : 5.0f);
    _cammentRecorderNode.style.height = ASDimensionMake(_showCammentRecorderNode ? cammentRecorderNodeHeight : 5.0f);

    ASInsetLayoutSpec *cammentRecorderNodeInsetsLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                    _showCammentRecorderNode ? 20.0f : .0f,
                    20.0f,
                    _showCammentRecorderNode ? 4.0f : .0f,
                    INFINITY)
                                child:_cammentRecorderNode];

    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec
            stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                 spacing:.0f
                          justifyContent:ASStackLayoutJustifyContentStart
                              alignItems:ASStackLayoutAlignItemsStretch
                                children:@[cammentRecorderNodeInsetsLayout,
                                        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                               child:_cammentsBlockNode]]];
    return stackLayoutSpec;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.contentNode.style.width = ASDimensionMake(constrainedSize.max.width);
    self.contentNode.style.height = ASDimensionMake(constrainedSize.max.height);

    ASInsetLayoutSpec *cammentButtonLayout = [self cammentButtonLayoutSpec:self.layoutConfig];
    ASLayoutSpec *camentBlockLayoutSpec = [self cammentBlockLayoutSpecThatFits:constrainedSize];

    _leftSidebarNode.style.width = ASDimensionMake(self.layoutConfig.leftSidebarWidth);
    camentBlockLayoutSpec.style.width = ASDimensionMake(150.0f);

    ASStackLayoutSpec *leftColumnStack = [ASStackLayoutSpec
            stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                 spacing:.0f
                          justifyContent:ASStackLayoutJustifyContentStart
                              alignItems:ASStackLayoutAlignItemsStart
                                children:@[
                                        _leftSidebarNode,
                                        camentBlockLayoutSpec
                                ]
    ];

    leftColumnStack.style.width = ASDimensionMake(_leftSidebarNode.style.width.value + camentBlockLayoutSpec.style.width.value);
    CGFloat leftLayoutInset = 0.0f;
    CGFloat leftColumnStackOffset = -leftColumnStack.style.width.value;
    if (_showCammentsBlock) {
        leftColumnStackOffset = -_leftSidebarNode.style.width.value;
    }

    if (_showLestSidebarNode) {
        leftColumnStackOffset = .0f;
    }

    ASInsetLayoutSpec *cammentsBlockLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0.0f, leftColumnStackOffset, 0.0f, INFINITY)
                                child:leftColumnStack];

    _cammentsBlockNode.style.height = ASDimensionMake(
            [cammentsBlockLayout layoutThatFits:constrainedSize].size.height);
    _leftSidebarNode.style.height = ASDimensionMake(
            [cammentsBlockLayout layoutThatFits:constrainedSize].size.height);

    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec
            stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                 spacing:.0f
                          justifyContent:ASStackLayoutJustifyContentStart
                              alignItems:ASStackLayoutAlignItemsStretch
                                children:@[cammentsBlockLayout]];

    stackLayoutSpec.style.height = self.contentNode.style.height;
    ASInsetLayoutSpec *stackLayoutInsetSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0.0f, leftLayoutInset, .0f, INFINITY)
                                child:stackLayoutSpec];

    ASOverlayLayoutSpec *cammentButtonOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.contentNode
                                                                                        overlay:cammentButtonLayout];

    ASOverlayLayoutSpec *cammentsBlockOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:cammentButtonOverlay
                                                                                        overlay:stackLayoutInsetSpec];
    if (self.showVideoAdsPlayerNode) {
        cammentsBlockOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:cammentsBlockOverlay
                                                                       overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                                                                                       self.videoAdsPlayerNodeAppearsFrame.origin.y - 8.0f,
                                                                                       self.videoAdsPlayerNodeAppearsFrame.origin.x - 15.0f,
                                                                                       INFINITY, INFINITY)
                                                                                                                      child:_adsVideoPlayerNode]];
    }
    return cammentsBlockOverlay;
}

- (ASInsetLayoutSpec *)cammentButtonLayoutSpec:(CMCammentOverlayLayoutConfig *)layoutConfig {
    ASInsetLayoutSpec *layoutSpec = nil;
    
    switch (layoutConfig.cammentButtonLayoutPosition) {

        case CMCammentOverlayLayoutPositionTopRight:
            layoutSpec = [ASInsetLayoutSpec
                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                            self.cammentButtonScreenSideVerticalInset,
                            INFINITY,
                            INFINITY,
                            _showLestSidebarNode ?
                                    - self.layoutConfig.leftSidebarWidth + _cammentButton.style.width.value * 2
                                    : (_showCammentsBlock ? 20.0f : -_cammentButton.style.width.value * 2))
                                        child:_cammentButton];
            break;
        case CMCammentOverlayLayoutPositionBottomRight:
            layoutSpec = [ASInsetLayoutSpec
                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                            INFINITY,
                            INFINITY,
                            self.cammentButtonScreenSideVerticalInset,
                            _showLestSidebarNode ?
                                    - self.layoutConfig.leftSidebarWidth + _cammentButton.style.width.value * 2
                                    : (_showCammentsBlock ? 20.0f : -_cammentButton.style.width.value * 2))
                                        child:_cammentButton];
            break;
    }
    return layoutSpec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (![context isAnimated]) {
        self.cammentRecorderNode.alpha = _showCammentRecorderNode ? 1.0f : 0.f;
        [super animateLayoutTransition:context];
        return;
    }
    
    UIView * snapshot = [self.cammentRecorderNode.view snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = self.cammentRecorderNode.view.bounds;
    snapshot.alpha = 1.0f;
    [self.cammentRecorderNode.view addSubview:snapshot];

    CGRect cammentBlockFinalFrame = [context finalFrameForNode:self.cammentsBlockNode];
    CGRect cammentBlockInitialFrame = [context initialFrameForNode:self.cammentsBlockNode];

    self.cammentsBlockNode.view.frame = CGRectMake(
            cammentBlockInitialFrame.origin.x,
            cammentBlockInitialFrame.origin.y,
            cammentBlockFinalFrame.size.width,
            MAX(cammentBlockFinalFrame.size.height, cammentBlockInitialFrame.size.height));

    [UIView animateWithDuration:0.3 animations:^{
        self.cammentsBlockNode.view.frame = CGRectMake(
                cammentBlockFinalFrame.origin.x,
                cammentBlockFinalFrame.origin.y,
                cammentBlockFinalFrame.size.width,
                MAX(cammentBlockFinalFrame.size.height, cammentBlockInitialFrame.size.height));
        self.cammentRecorderNode.frame = [context finalFrameForNode:self.cammentRecorderNode];
        self.cammentRecorderNode.alpha = _showCammentRecorderNode ? 1.0f : 0.f;
        self.cammentButton.frame = [context finalFrameForNode:self.cammentButton];
        self.leftSidebarNode.frame = [context finalFrameForNode:self.leftSidebarNode];
        
        if (self.contentNode) {
            self.contentNode.frame = [context finalFrameForNode:self.contentNode];
        }
        
        if (_showVideoAdsPlayerNode) {
            self.adsVideoPlayerNode.frame = [context finalFrameForNode:self.adsVideoPlayerNode];
        }

    } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
        self.cammentsBlockNode.frame = cammentBlockFinalFrame;
        [context completeTransition:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didCompleteLayoutTransition)]) {
            [self.delegate didCompleteLayoutTransition];
        }
    }];
}

- (void)handleCammentButtonPanGesture:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded
            || sender.state == UIGestureRecognizerStateFailed
            || sender.state == UIGestureRecognizerStateCancelled) {

        _cammentButtonScreenSideVerticalInset = self.layoutConfig.cammentButtonLayoutVerticalInset;
        [self transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.cammentButton.view.superview];

        switch (self.layoutConfig.cammentButtonLayoutPosition) {
            case CMCammentOverlayLayoutPositionTopRight:
                if (translation.y > 0) {
                    _cammentButtonScreenSideVerticalInset = self.layoutConfig.cammentButtonLayoutVerticalInset + translation.y;
                    [self setNeedsLayout];
                }

                if (translation.y > self.layoutConfig.cammentButtonLayoutVerticalInset) {
                    [_cammentButton cancelLongPressGestureRecognizer];
                }

                // if pull down more then 1/3 of screen height
                if (translation.y > self.bounds.size.height / 3) {
                    [sender setEnabled:NO];
                    [_cammentButton cancelLongPressGestureRecognizer];
                    [_delegate handleShareAction];
                    [sender setEnabled:YES];
                }
                break;
            case CMCammentOverlayLayoutPositionBottomRight:
                if (translation.y < 0) {
                    _cammentButtonScreenSideVerticalInset = self.layoutConfig.cammentButtonLayoutVerticalInset - translation.y;
                    [self setNeedsLayout];
                }

                if (-translation.y > self.bounds.size.height / 3) {
                    [sender setEnabled:NO];
                    [_cammentButton cancelLongPressGestureRecognizer];
                    [_delegate handleShareAction];
                    [sender setEnabled:YES];
                }
                break;
        }
    }
}
@end
