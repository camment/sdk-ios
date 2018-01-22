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
#import "ASDimension.h"

@interface CMCammentsOverlayViewNode () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat cammentButtonScreenSideVerticalInset;
@property (nonatomic, assign) CGFloat leftSideBarMenuLeftInset;
@property (nonatomic, assign) CGFloat cammentBlockWidth;
@property (nonatomic, strong) UIPanGestureRecognizer *cammentPanDownGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *sideBarPanGestureRecognizer;

@property(nonatomic) CGFloat sideBarTransitionInitialValue;
@end

@implementation CMCammentsOverlayViewNode

- (instancetype)initWithLayoutConfig:(CMCammentOverlayLayoutConfig *)layoutConfig {
    self = [super init];
    
    if (self) {
        self.layoutConfig = layoutConfig;

        _cammentsBlockNode = [CMCammentsBlockNode new];
        _leftSidebarNode = [ASDisplayNode new];
        _cammentButton = [CMCammentButton new];
        _cammentRecorderNode = [CMCammentRecorderPreviewNode new];
        _adsVideoPlayerNode = [CMAdsVideoPlayerNode new];
        _adsVideoPlayerNode.debugName = @"CMAdsVideoPlayerNode";
        
        _contentNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            return _contentView ?: [UIView new];
        }];
        self.cammentBlockWidth = 150.0f;
        self.cammentButtonScreenSideVerticalInset = layoutConfig.cammentButtonLayoutVerticalInset;
        self.cammentPanDownGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCammentButtonPanGesture:)];
        self.sideBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSideBarPanGesture:)];
        self.sideBarPanGestureRecognizer.maximumNumberOfTouches = 1;
        self.sideBarPanGestureRecognizer.delegate = self;

        self.showCammentsBlock = YES;
        self.showLeftSidebarNode = NO;
        [self updateLeftSideBarMenuLeftInset];

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
    [self.view addGestureRecognizer:_sideBarPanGestureRecognizer];
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
    camentBlockLayoutSpec.style.width = ASDimensionMake(self.cammentBlockWidth);

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

    if (_showLeftSidebarNode) {
        leftColumnStackOffset = .0f;
    }

    leftColumnStackOffset = -leftColumnStack.style.width.value + self.leftSideBarMenuLeftInset;

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
                                                                                       self.videoAdsPlayerNodeAppearsFrame.origin.y + 5,
                                                                                       self.videoAdsPlayerNodeAppearsFrame.origin.x + 80,
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
                            _showLeftSidebarNode ?
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
                            _showLeftSidebarNode ?
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
        self.leftSidebarNode.alpha = _showLeftSidebarNode ? 1.0f : 0.f;
        
        if (!_showLeftSidebarNode) {
            self.cammentButton.alpha = _leftSideBarMenuLeftInset / self.cammentBlockWidth / 2.0f;
        } else {
            self.cammentButton.alpha =  .0f;
        }
        
        [super animateLayoutTransition:context];
        return;
    }

    UIView * snapshot = [self.cammentRecorderNode.view snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = self.cammentRecorderNode.bounds;
    snapshot.alpha = 1.0f;
    [self.cammentRecorderNode.view addSubview:snapshot];

    CGRect cammentBlockFinalFrame = [context finalFrameForNode:self.cammentsBlockNode];
    CGRect cammentBlockInitialFrame = [context initialFrameForNode:self.cammentsBlockNode];

    self.cammentsBlockNode.frame = CGRectMake(
            cammentBlockInitialFrame.origin.x,
            cammentBlockInitialFrame.origin.y,
            cammentBlockFinalFrame.size.width,
            MAX(cammentBlockFinalFrame.size.height, cammentBlockInitialFrame.size.height));

    [self.cammentsBlockNode.collectionNode waitUntilAllUpdatesAreProcessed];

    if (_showLeftSidebarNode) {
        self.leftSidebarNode.alpha = 1.0f;
    }

    [UIView animateWithDuration:0.3
                          delay:.0f
                        options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.cammentsBlockNode.frame = CGRectMake(
                                 cammentBlockFinalFrame.origin.x,
                                 cammentBlockFinalFrame.origin.y,
                                 cammentBlockFinalFrame.size.width,
                                 MAX(cammentBlockFinalFrame.size.height, cammentBlockInitialFrame.size.height));
                         self.cammentRecorderNode.frame = [context finalFrameForNode:self.cammentRecorderNode];
                         self.cammentRecorderNode.alpha = _showCammentRecorderNode ? 1.0f : 0.f;
                         self.cammentButton.frame = [context finalFrameForNode:self.cammentButton];
                         
                         if (!_showLeftSidebarNode) {
                             self.cammentButton.alpha = _leftSideBarMenuLeftInset / self.cammentBlockWidth / 2.0f;
                         } else {
                             self.cammentButton.alpha =  .0f;
                         }
                         
                         self.leftSidebarNode.frame = [context finalFrameForNode:self.leftSidebarNode];

                         if (self.contentNode) {
                             self.contentNode.frame = [context finalFrameForNode:self.contentNode];
                         }

                         if (_showVideoAdsPlayerNode) {
                             self.adsVideoPlayerNode.frame = [context finalFrameForNode:self.adsVideoPlayerNode];
                         }

                     }
                     completion:^(BOOL finished) {
                         [snapshot removeFromSuperview];
                         self.cammentsBlockNode.frame = CGRectMake(self.cammentsBlockNode.frame.origin.x,
                                 self.cammentsBlockNode.frame.origin.y,
                                 self.cammentsBlockNode.frame.size.width,
                                 cammentBlockFinalFrame.size.height);
                         if (!_showLeftSidebarNode) {
                             self.leftSidebarNode.alpha = .0f;
                         }
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

- (void)updateLeftSideBarMenuLeftInset {
    _leftSideBarMenuLeftInset = .0f;
    
    if (_showCammentsBlock) {
        _leftSideBarMenuLeftInset = self.cammentBlockWidth;
    }
    
    if (_showLeftSidebarNode) {
        _leftSideBarMenuLeftInset = self.cammentBlockWidth + self.layoutConfig.leftSidebarWidth;
    }
}

- (void)handleSideBarPanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self updateLeftSideBarMenuLeftInset];
        self.sideBarTransitionInitialValue = _leftSideBarMenuLeftInset;
    } else if (sender.state == UIGestureRecognizerStateEnded
            || sender.state == UIGestureRecognizerStateFailed
            || sender.state == UIGestureRecognizerStateCancelled) {
        
        [self updateLeftSideBarMenuLeftInset];
        [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.leftSidebarNode.view.superview];
        
        _leftSideBarMenuLeftInset = self.sideBarTransitionInitialValue + translation.x;
        
        _showCammentsBlock = _leftSideBarMenuLeftInset > self.cammentBlockWidth / 2.0f;
        
        if (_leftSideBarMenuLeftInset <= self.cammentBlockWidth) {
            self.cammentButton.alpha = _leftSideBarMenuLeftInset / self.cammentBlockWidth - 0.5;
        } else {
            self.cammentButton.alpha =  0.5 - (_leftSideBarMenuLeftInset - self.cammentBlockWidth) / self.layoutConfig.leftSidebarWidth;
        }
        
        BOOL showLeftSidebarNode = _leftSideBarMenuLeftInset > self.cammentBlockWidth;
        self.leftSidebarNode.alpha = showLeftSidebarNode ? 1.0f : 0.0f;
        
        _showLeftSidebarNode = _leftSideBarMenuLeftInset > self.cammentBlockWidth + self.layoutConfig.leftSidebarWidth / 2;
        
        if (_leftSideBarMenuLeftInset > self.cammentBlockWidth + self.layoutConfig.leftSidebarWidth) {
            _leftSideBarMenuLeftInset = self.cammentBlockWidth + self.layoutConfig.leftSidebarWidth;
        }
        
        if (_leftSideBarMenuLeftInset < .0f) {
            _leftSideBarMenuLeftInset = .0f;
        }
        
        [self setNeedsLayout];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.sideBarPanGestureRecognizer isEqual:gestureRecognizer]) {
        CGRect frame = self.cammentButton.view.frame;
        CGPoint locationOfTouch = [gestureRecognizer locationOfTouch:0 inView:self.cammentButton.view.superview];
        BOOL containsPoint = CGRectContainsPoint(frame, locationOfTouch);
        return !containsPoint;
    }
    return YES;
}


@end
