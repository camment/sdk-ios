//
//  CMActivityIndicator.m
//  Camment OY
//
//  Created by Alexander Fedosov on 02.08.15.
//  Copyright (c) 2015 Alexander Fedosov. All rights reserved.
//

#import "CMActivityIndicator.h"

@interface CMActivityIndicator () <CAAnimationDelegate>

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, assign, getter=isAnimating) BOOL animated;
@property(nonatomic, assign) BOOL shouldRestoreAnimation;

@property(nonatomic, strong) CABasicAnimation *fullRotation;
@end

@implementation CMActivityIndicator

- (instancetype)init{
    if ([super init]) {
        self.image = [UIImage imageNamed:@"sofa_spinner"
                inBundle:[NSBundle cammentSDKBundle]
           compatibleWithTraitCollection:nil];
        [self configure];
    }
    return self;
}

- (void)configure {
    self.backgroundColor = [UIColor clearColor];

    self.imageView = [UIImageView new];
    self.imageView.image = self.image;
    [self addSubview:self.imageView];
    
    if (self.animateAfterLoad) {
        [self startAnimation];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.frame = self.bounds;
}

- (void)dealloc {
    [self stopAnimation];
}

- (void)startAnimation {
    _animated = YES;
    self.imageView.layer.transform = CATransform3DIdentity;
    self.fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.fullRotation.fromValue = @0.0f;
    self.fullRotation.toValue = @((float)-(2 * M_PI)); // added this minus sign as i want to rotate it to anticlockwise
    self.fullRotation.speed = .5f;              // Changed rotation speed
    self.fullRotation.repeatCount = MAXFLOAT;
    self.fullRotation.delegate = self;
    [self.imageView.layer addAnimation:self.fullRotation forKey:@"360"];

}

- (void)stopAnimation {
    _animated = NO;
    self.fullRotation.delegate = nil;
    [self.imageView.layer removeAnimationForKey:@"360"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_animated && !flag) {
        [self startAnimation];
    }
}

@end
