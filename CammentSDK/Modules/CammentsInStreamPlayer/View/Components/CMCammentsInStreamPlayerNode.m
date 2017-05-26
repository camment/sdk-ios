//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMCammentsInStreamPlayerNode.h"
#import "CMStreamPlayerNode.h"
#import "CMCammentsBlockNode.h"
#import "CMCammentButton.h"
#import "CMCammentRecorderPreviewNode.h"


@interface CMCammentsInStreamPlayerNode ()

@end

@implementation CMCammentsInStreamPlayerNode

- (instancetype)init {
    self = [super init];

    if (self) {
        self.showCammentsBlock = YES;
        self.streamPlayerNode = [CMStreamPlayerNode new];
        self.cammentsBlockNode = [CMCammentsBlockNode new];
        self.cammentButton = [CMCammentButton new];
        self.cammentRecorderNode = [CMCammentRecorderPreviewNode new];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.streamPlayerNode.style.width = ASDimensionMake(constrainedSize.max.width);
    self.streamPlayerNode.style.height = ASDimensionMake(constrainedSize.max.height);

    ASInsetLayoutSpec *cammentButtonLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(20.0f, INFINITY, INFINITY, 20.0f)
                                child:_cammentButton];

    CGFloat leftLayoutInset = 20.0f;
    _cammentsBlockNode.style.width = ASDimensionMake(100.0f);
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
                    .0f,
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
    stackLayoutSpec.style.height = self.streamPlayerNode.style.height;
    ASInsetLayoutSpec *stackLayoutInsetSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(4.0f, leftLayoutInset, .0f, INFINITY)
                                child:stackLayoutSpec];

    ASOverlayLayoutSpec *cammentButtonOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_streamPlayerNode
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
        [context completeTransition:finished];
    }];
}


@end