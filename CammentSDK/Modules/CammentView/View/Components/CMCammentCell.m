//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "Camment.h"
#import "UIColorMacros.h"

@interface CMCammentCell ()
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

@implementation CMCammentCell

- (instancetype)initWithCamment:(Camment *)camment {
    self = [super init];
    if (self) {
        _camment = camment;
        self.cammentNode = [[CMCammentNode alloc] initWithCamment:camment];
        self.borderColor = UIColorFromRGB(0x3B3B3B).CGColor;
        self.borderWidth = 2.0f;
        self.cornerRadius = 4.0f;
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
    return layoutSpec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    [UIView animateWithDuration:0.5 animations:^{
        _cammentNode.frame = CGRectMake(
                [context finalFrameForNode:self.cammentNode].origin.x,
                [context finalFrameForNode:self.cammentNode].origin.y,
                _expanded ? 90.0f : 45.0f,
                _expanded ? 90.0f : 45.0f);
    } completion:^(BOOL finished) {
        [context completeTransition:finished];
    }];
}

@end
