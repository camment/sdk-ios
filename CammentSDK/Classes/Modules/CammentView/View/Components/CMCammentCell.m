//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "CMCamment.h"
#import "UIColorMacros.h"
#import "CMCammentCellDisplayingContext.h"
#import "CMCammentDeliveryIndicator.h"

@interface CMCammentCell ()

@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property(nonatomic, strong) CMCammentDeliveryIndicator *deliveryIndicator;
@end

@implementation CMCammentCell

- (instancetype)initWithDisplayContext:(CMCammentCellDisplayingContext *)context {
    self = [super init];
    if (self) {
        _displayingContext = context;
        self.cammentNode = [[CMCammentNode alloc] initWithCamment:context.camment];
        self.deliveryIndicator = [CMCammentDeliveryIndicator new];
        self.deliveryIndicator.deliveryStatus = context.camment.status.deliveryStatus;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];

    UILongPressGestureRecognizer *longPressGestureRecognizer = [UILongPressGestureRecognizer new];
    [longPressGestureRecognizer addTarget:self action:@selector(handleLongPressAction:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    self.longPressGestureRecognizer = longPressGestureRecognizer;
}

- (void)handleLongPressAction:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(cammentCellDidHandleLongPressAction:)]) {
        [self.delegate cammentCellDidHandleLongPressAction:self];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.cammentNode.style.preferredSize = CGSizeMake(
            _expanded ? 90.0f : 45.0f,
            _expanded ? 90.0f : 45.0f);
    ASWrapperLayoutSpec *layoutSpec = [ASWrapperLayoutSpec wrapperWithLayoutElement:_cammentNode];
    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(1.0f, 1.0f, INFINITY, INFINITY)
                                                                                child:self.deliveryIndicator];
    ASOverlayLayoutSpec *overlayLayoutSpec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:layoutSpec
                                                                                     overlay:insetLayoutSpec];
    return overlayLayoutSpec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (![context isAnimated]) {
        [super animateLayoutTransition:context];
        return;
    }

    [UIView animateWithDuration:self.defaultLayoutTransitionDuration animations:^{
        _cammentNode.frame = [context finalFrameForNode:self.cammentNode];
    }                completion:^(BOOL finished) {
        [context completeTransition:finished];
    }];
}

- (void)updateWithDisplayingContext:(CMCammentCellDisplayingContext *)context {
    _displayingContext = context;
    self.deliveryIndicator.deliveryStatus = context.camment.status.deliveryStatus;
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

@end
