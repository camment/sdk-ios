//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CMOneThirdScaleAnimation.h"


@implementation CMOneThirdScaleAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.property = [POPAnimatableProperty propertyWithName:kPOPLayerScaleXY];
        self.springBounciness = 5.0f;
        self.springSpeed = 10.0f;
    }

    return self;
}

+ (CMOneThirdScaleAnimation *)scaleUpAnimation {
    CMOneThirdScaleAnimation *animation = [CMOneThirdScaleAnimation new];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.5f, 1.5f)];
    return animation;
}

+ (CMOneThirdScaleAnimation *)scaleDownAnimation {
    CMOneThirdScaleAnimation *animation = [CMOneThirdScaleAnimation new];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0f, 1.0f)];
    return animation;
}


@end
