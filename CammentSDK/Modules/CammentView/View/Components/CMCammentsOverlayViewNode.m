//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsOverlayViewNode.h"
#import "CMCammentsBlockNode.h"
#import "CMCammentButton.h"
#import "CMCammentRecorderPreviewNode.h"
#import "POPSpringAnimation.h"
#import "CMCammentOverlayLayoutConfig.h"

@interface CMCammentsOverlayViewNode ()

@property (nonatomic, assign) CGFloat cammentButtonScreenSideVerticalInset;
@property (nonatomic, strong) UIPanGestureRecognizer *cammentPanDownGestureRecognizer;

@property(nonatomic, strong) CMCammentOverlayLayoutConfig *layoutConfig;
@end

@implementation CMCammentsOverlayViewNode

- (instancetype)init {
    CMCammentOverlayLayoutConfig *layoutConfig = [CMCammentOverlayLayoutConfig new];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        layoutConfig.cammentButtonLayoutPosition = CMCammentOverlayLayoutPositionTopRight;
        layoutConfig.cammentButtonLayoutVerticalInset = 20.0f;
    } else {
        layoutConfig.cammentButtonLayoutPosition = CMCammentOverlayLayoutPositionBottomRight;
        layoutConfig.cammentButtonLayoutVerticalInset = 80.0f;
    }
    
    return [self initWithLayoutConfig:layoutConfig];
}


- (instancetype)initWithLayoutConfig:(CMCammentOverlayLayoutConfig *)layoutConfig {
    self = [super init];
    
    if (self) {
        self.layoutConfig = layoutConfig;
        self.showCammentsBlock = YES;
        _cammentsBlockNode = [CMCammentsBlockNode new];
        _cammentButton = [CMCammentButton new];
        _cammentRecorderNode = [CMCammentRecorderPreviewNode new];
        _contentView = [UIView new];
        _contentNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            return _contentView;
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

    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)didLoad {
    [super didLoad];
    [self.cammentButton.view addGestureRecognizer:_cammentPanDownGestureRecognizer];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.contentNode.style.width = ASDimensionMake(constrainedSize.max.width);
    self.contentNode.style.height = ASDimensionMake(constrainedSize.max.height);

    ASInsetLayoutSpec *cammentButtonLayout = [self cammentButtonLayoutSpec:self.layoutConfig];

    CGFloat leftLayoutInset = 0.0f;
    _cammentsBlockNode.style.width = ASDimensionMake(120.0f);
    ASInsetLayoutSpec *cammentsBlockLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0.0f, _showCammentsBlock ? .0f : -_cammentsBlockNode.style.width.value, 0.0f, INFINITY)
                                child:_cammentsBlockNode];

    CGFloat cammentRecorderNodeWidth = [_cammentRecorderNode layoutThatFits:ASSizeRangeMake(CGSizeMake(104, 90))].size.width;
    CGFloat cammentRecorderNodeHeight = [_cammentRecorderNode layoutThatFits:ASSizeRangeMake(CGSizeMake(104, 90))].size.height;
    _cammentRecorderNode.style.width = ASDimensionMake(_showCammentRecorderNode ? cammentRecorderNodeWidth : 1.0f);
    _cammentRecorderNode.style.height = ASDimensionMake(_showCammentRecorderNode ? cammentRecorderNodeHeight : .0f);
    ASInsetLayoutSpec *cammentRecorderNodeInsetsLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                    _showCammentRecorderNode ? 20.0f : .0f,
                    20.0f,
                    _showCammentRecorderNode ? 4.0f : .0f,
                    INFINITY)
                                child:_cammentRecorderNode];
    _cammentsBlockNode.style.height = ASDimensionMake(
            [cammentsBlockLayout layoutThatFits:constrainedSize].size.height);
    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec
            stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                 spacing:.0f
                          justifyContent:ASStackLayoutJustifyContentStart
                              alignItems:ASStackLayoutAlignItemsStretch
                                children:@[cammentRecorderNodeInsetsLayout, cammentsBlockLayout]];
    stackLayoutSpec.style.height = self.contentNode.style.height;
    ASInsetLayoutSpec *stackLayoutInsetSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(4.0f, leftLayoutInset, .0f, INFINITY)
                                child:stackLayoutSpec];

    ASOverlayLayoutSpec *cammentButtonOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.contentNode
                                                                                        overlay:cammentButtonLayout];

    ASOverlayLayoutSpec *cammentsBlockOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:cammentButtonOverlay
                                                                                        overlay:stackLayoutInsetSpec];
    return cammentsBlockOverlay;
}

- (ASInsetLayoutSpec *)cammentButtonLayoutSpec:(CMCammentOverlayLayoutConfig *)layoutConfig {
    ASInsetLayoutSpec *layoutSpec = nil;

    switch (layoutConfig.cammentButtonLayoutPosition) {

        case CMCammentOverlayLayoutPositionTopLeft:
        case CMCammentOverlayLayoutPositionTopRight:
            layoutSpec = [ASInsetLayoutSpec
                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                            self.cammentButtonScreenSideVerticalInset,
                            INFINITY,
                            INFINITY,
                            _showCammentsBlock ? 20.0f : -_cammentButton.style.width.value * 2)
                                        child:_cammentButton];
            break;
        case CMCammentOverlayLayoutPositionBottomLeft:
        case CMCammentOverlayLayoutPositionBottomRight:
            layoutSpec = [ASInsetLayoutSpec
                    insetLayoutSpecWithInsets:UIEdgeInsetsMake(
                            INFINITY,
                            INFINITY,
                            self.cammentButtonScreenSideVerticalInset,
                            _showCammentsBlock ? 20.0f : -_cammentButton.style.width.value * 2)
                                        child:_cammentButton];
            break;
    }
    return layoutSpec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    UIView * snapshot = [self.cammentRecorderNode.view snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = self.cammentRecorderNode.view.bounds;
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
        self.cammentButton.frame = [context finalFrameForNode:self.cammentButton];
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

            case CMCammentOverlayLayoutPositionTopLeft:
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
            case CMCammentOverlayLayoutPositionBottomLeft:
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
