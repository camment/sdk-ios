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
@property(nonatomic, strong) ASImageNode *notWatchedIndicator;
@end

@implementation CMCammentCell

- (instancetype)initWithDisplayContext:(CMCammentCellDisplayingContext *)context {
    self = [super init];
    if (self) {
        _displayingContext = context;
        self.cammentNode = [[CMCammentNode alloc] initWithCamment:context.camment];
        self.deliveryIndicator = [CMCammentDeliveryIndicator new];
        self.deliveryIndicator.deliveryStatus = _displayingContext.camment.status.deliveryStatus;
        self.deliveryIndicator.hidden = !context.shouldShowDeliveryStatus;

        self.notWatchedIndicator = [[ASImageNode alloc] init];
        self.notWatchedIndicator.contentMode = UIViewContentModeTopRight;
        self.notWatchedIndicator.hidden = !context.shouldShowWatchedStatus;
        self.notWatchedIndicator.alpha = !context.camment.status.isWatched;

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];

    self.notWatchedIndicator.image = [UIImage imageNamed:@"not_watched"
                                                inBundle:[NSBundle cammentSDKBundle]
                           compatibleWithTraitCollection:nil];

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
    self.cammentNode.style.flexGrow = 1.0f;
    self.notWatchedIndicator.style.flexGrow = 1.0f;

    ASStackLayoutSpec *finalLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                 spacing:-1.0f
                                                                          justifyContent:ASStackLayoutJustifyContentStart
                                                                              alignItems:ASStackLayoutAlignItemsStart
                                                                                children:@[_deliveryIndicator, [ASOverlayLayoutSpec overlayLayoutSpecWithChild:_cammentNode
                                                                                                                                                       overlay:_notWatchedIndicator]]];
    finalLayoutSpec.style.flexGrow = .0f;
    finalLayoutSpec.style.flexShrink = .0f;


    ASAbsoluteLayoutSpec *spec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingSizeToFit children:@[finalLayoutSpec]];
    spec.style.height = ASDimensionMake(_expanded ? 90.0f : 45.0f);
    spec.style.width = ASDimensionMake((_expanded ? 90.0f : 45.0f) + [self layoutGuidesOffsets].left);

    return spec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (![context isAnimated]) {
        _notWatchedIndicator.alpha = !self.displayingContext.camment.status.isWatched;
        [super animateLayoutTransition:context];
        return;
    }

    ASSizeRange sizeRange = ASSizeRangeMake(CGSizeZero, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX));
    CGSize size = [self layoutThatFits:sizeRange].size;
    CGRect frame = self.frame;
    frame.size = size;

    [UIView animateWithDuration:self.defaultLayoutTransitionDuration
                          delay: self.defaultLayoutTransitionDelay
                        options: self.defaultLayoutTransitionOptions
                     animations:^{
                         self.frame = frame;
                         _cammentNode.frame = [context finalFrameForNode:self.cammentNode];
                         _cammentNode.videoPlayerNode.frame = _cammentNode.bounds;
                         _deliveryIndicator.frame = [context finalFrameForNode:self.deliveryIndicator];
                         _notWatchedIndicator.alpha = !self.displayingContext.camment.status.isWatched;
                     }                completion:^(BOOL finished) {
                         [context completeTransition:finished];
                     }];
}

- (void)updateWithDisplayingContext:(CMCammentCellDisplayingContext *)context {
    _displayingContext = context;
    self.deliveryIndicator.deliveryStatus = context.camment.status.deliveryStatus;
    self.deliveryIndicator.hidden = !context.shouldShowDeliveryStatus;
    self.notWatchedIndicator.hidden = !context.shouldShowWatchedStatus;
    [self.deliveryIndicator transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (UIEdgeInsets)layoutGuidesOffsets {
    return UIEdgeInsetsMake(.0f, 11.0f, .0f, .0f);
}

@end
