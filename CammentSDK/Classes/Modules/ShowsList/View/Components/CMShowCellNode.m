//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMShowCellNode.h"
#import "CMAPIShow.h"
#import "CMShow.h"
#import "CMOneThirdScaleAnimation.h"

@interface CMShowCellNode () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) UILongPressGestureRecognizer *tapGestureRecognizer;
@end

@implementation CMShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        _show = show;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    
    self.clipsToBounds = NO;
    self.cornerRadius = 15.0f;

    self.tapGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tapGestureRecognizer.minimumPressDuration = 0.0f;
    self.tapGestureRecognizer.delegate = self;
    self.tapGestureRecognizer.delaysTouchesBegan = NO;
    self.tapGestureRecognizer.delaysTouchesEnded = NO;
    self.tapGestureRecognizer.allowableMovement = 20.0f;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)layout {
    [super layout];
    [self updateShadow];
}

- (void)updateShadow {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 15.0f;
    self.layer.shadowOpacity = .3f;
    self.layer.shadowOffset = CGSizeMake(.0f, .0f);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:15.0f].CGPath;
}

- (void)handleTap:(UILongPressGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStatePossible) {
        [self pop_removeAllAnimations];
        CMOneThirdScaleAnimation * animation = [CMOneThirdScaleAnimation scaleDownAnimation];
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(.95f, .95f)];
        animation.springBounciness = 5.0f;
        animation.springSpeed = 60.0f;
        [self pop_addAnimation:animation forKey:@"tap"];
    } else if (recognizer.state == UIGestureRecognizerStateCancelled
               || recognizer.state == UIGestureRecognizerStateEnded
               || recognizer.state == UIGestureRecognizerStateFailed) {
        [self pop_removeAllAnimations];
        CMOneThirdScaleAnimation * animation = [CMOneThirdScaleAnimation scaleDownAnimation];
        [self pop_addAnimation:animation forKey:@"tap"];
        if (recognizer.state == UIGestureRecognizerStateEnded
                && self.delegate && [self.delegate respondsToSelector:@selector(showCellNode:didSelectShow:)]) {
            [self.delegate showCellNode:self didSelectShow:self.show];
            [self cancelTapGesture];
        }
    }
}

- (ASLayoutSpec *)contentNode {
    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                child:[ASDisplayNode new]];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASLayoutSpec *contentNode = [self contentNode];

    contentNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMakeWithFraction(1), ASDimensionMakeWithFraction(1));

    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                child:contentNode];
}

- (void)playPressAnimation {

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void)cancelTapGesture {
    [self.tapGestureRecognizer setEnabled:NO];
    [self.tapGestureRecognizer setEnabled:YES];
}


- (UIImage *)thumbnailImage {
    return nil;
}
@end
