//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsInStreamPlayerNode.h"
#import "CMStreamPlayerNode.h"
#import "CMCammentsBlockNode.h"
#import "CMCammentButton.h"
#import "CMCammentRecorderPreviewNode.h"
#import "POPSpringAnimation.h"
#import "CMWebContentPlayerNode.h"


@interface CMCammentsInStreamPlayerNode ()

@property (nonatomic, assign) CGFloat cammentButtonTopInset;
@property (nonatomic, strong) UIPanGestureRecognizer *cammentPanDownGestureRecognizer;

@end

@implementation CMCammentsInStreamPlayerNode

- (instancetype)init {
    self = [super init];

    if (self) {
        self.showCammentsBlock = YES;
        _contentViewerNode = [CMStreamPlayerNode new];
        self.cammentsBlockNode = [CMCammentsBlockNode new];
        self.cammentButton = [CMCammentButton new];
        self.cammentRecorderNode = [CMCammentRecorderPreviewNode new];

        self.cammentButtonTopInset = 20.0f;
        self.cammentPanDownGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleCammentButtonPanGesture:)];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)setContentType:(CMContentType)contentType {
    _contentType = contentType;
    switch (_contentType) {
        case CMContentTypeVideo:
            _contentViewerNode = [CMStreamPlayerNode new];
            break;
        case CMContentTypeHTML:
            _contentViewerNode = [CMWebContentPlayerNode new];
            break;
    }

    [self transitionLayoutWithAnimation:NO shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)didLoad {
    [super didLoad];
    [self.cammentButton.view addGestureRecognizer:_cammentPanDownGestureRecognizer];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASDisplayNode *contentViewerNode = (id) self.contentViewerNode;
    contentViewerNode.style.width = ASDimensionMake(constrainedSize.max.width);
    contentViewerNode.style.height = ASDimensionMake(constrainedSize.max.height);

    ASInsetLayoutSpec *cammentButtonLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.cammentButtonTopInset, INFINITY, INFINITY, 20.0f)
                                child:_cammentButton];

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
    stackLayoutSpec.style.height = contentViewerNode.style.height;
    ASInsetLayoutSpec *stackLayoutInsetSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(4.0f, leftLayoutInset, .0f, INFINITY)
                                child:stackLayoutSpec];

    ASOverlayLayoutSpec *cammentButtonOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:contentViewerNode
                                                                                        overlay:cammentButtonLayout];

    ASOverlayLayoutSpec *cammentsBlockOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:cammentButtonOverlay
                                                                                        overlay:stackLayoutInsetSpec];
    return cammentsBlockOverlay;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    UIView * snapshot = [self.cammentRecorderNode.view snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = self.cammentRecorderNode.view.bounds;
    [self.cammentRecorderNode.view addSubview:snapshot];

    CGRect cammentBlockFinalFrame = [context finalFrameForNode:self.cammentsBlockNode];
    CGRect cammentBlockInitialFrame = [context initialFrameForNode:self.cammentsBlockNode];

    CGRect cammentButtonFinalFrame = [context finalFrameForNode:self.cammentButton];

    RACSubject<NSNumber *> *animationSubject = [RACSubject new];

    self.cammentsBlockNode.view.frame = CGRectMake(
            cammentBlockInitialFrame.origin.x,
            cammentBlockInitialFrame.origin.y,
            cammentBlockFinalFrame.size.width,
            MAX(cammentBlockFinalFrame.size.height, cammentBlockInitialFrame.size.height));

    [UIView animateWithDuration:0.5 animations:^{
        self.cammentsBlockNode.view.frame = CGRectMake(
                cammentBlockFinalFrame.origin.x,
                cammentBlockFinalFrame.origin.y,
                cammentBlockFinalFrame.size.width,
                MAX(cammentBlockFinalFrame.size.height, cammentBlockInitialFrame.size.height));;
        self.cammentRecorderNode.frame = [context finalFrameForNode:self.cammentRecorderNode];
    } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
        self.cammentsBlockNode.frame = cammentBlockFinalFrame;
        [animationSubject sendNext:@(finished)];
    }];

    POPSpringAnimation *cammentButtonAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    cammentButtonAnimation.toValue = [NSValue valueWithCGRect:cammentButtonFinalFrame];
    cammentButtonAnimation.springSpeed = 10;
    cammentButtonAnimation.springBounciness = 10;
    [cammentButtonAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [animationSubject sendNext:@(finished)];
    }];
    [self.cammentButton.view pop_addAnimation:cammentButtonAnimation forKey:@"frame"];

    __block NSInteger firedAnimation = 0;
    [animationSubject subscribeNext:^(NSNumber *x) {
        firedAnimation++;
        if (firedAnimation == 2) {
            [context completeTransition:YES];
        }
    }];
}

- (void)handleCammentButtonPanGesture:(UIPanGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded
            || sender.state == UIGestureRecognizerStateFailed
            || sender.state == UIGestureRecognizerStateCancelled) {

        _cammentButtonTopInset = 20.0f;
        [self transitionLayoutWithAnimation:YES shouldMeasureAsync:YES measurementCompletion:nil];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [sender translationInView:self.cammentButton.view.superview];
        if (translation.y > 0) {
            _cammentButtonTopInset = 20.0f + translation.y;
            [self setNeedsLayout];
        }

        if (translation.y > 50) {
            [sender setEnabled:NO];
            [_cammentButton cancelLongPressGestureRecognizer];
            [_delegate handleShareAction];
            [sender setEnabled:YES];
        }
    }
}
@end
