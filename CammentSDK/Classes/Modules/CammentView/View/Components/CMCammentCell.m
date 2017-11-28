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
        self.deliveryIndicator.deliveryStatus = _displayingContext.camment.status.deliveryStatus;
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

- (void)didEnterDisplayState {
    [super didEnterDisplayState];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deliveryIndicator transitionLayoutWithAnimation:YES
                                           shouldMeasureAsync:NO
                                        measurementCompletion:nil];
    });
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
    ASStackLayoutSpec *finalLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                 spacing:-1.0f
                                                                          justifyContent:ASStackLayoutJustifyContentStart
                                                                              alignItems:ASStackLayoutAlignItemsStart
                                                                                children:@[_deliveryIndicator, _cammentNode]];
    finalLayoutSpec.style.flexGrow = .0f;
    finalLayoutSpec.style.flexShrink = .0f;
    
    return finalLayoutSpec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (![context isAnimated]) {
        [super animateLayoutTransition:context];
        return;
    }

    [UIView animateWithDuration:self.defaultLayoutTransitionDuration animations:^{
        _cammentNode.frame = [context finalFrameForNode:self.cammentNode];
        _deliveryIndicator.frame = [context finalFrameForNode:self.deliveryIndicator];
    }                completion:^(BOOL finished) {
        [context completeTransition:finished];
    }];
}

- (void)updateWithDisplayingContext:(CMCammentCellDisplayingContext *)context {
    _displayingContext = context;
    self.deliveryIndicator.deliveryStatus = context.camment.status.deliveryStatus;
    [self.deliveryIndicator transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (UIEdgeInsets)layoutGuidesOffsets {
    return UIEdgeInsetsMake(.0f, 11.0f, .0f, .0f);
}

@end
