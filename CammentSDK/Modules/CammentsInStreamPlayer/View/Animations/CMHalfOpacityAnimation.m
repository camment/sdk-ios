//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMHalfOpacityAnimation.h"


@implementation CMHalfOpacityAnimation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
        self.springBounciness = 5.0f;
        self.springSpeed = 10.0f;
    }

    return self;
}

+ (CMHalfOpacityAnimation *)opacityUpAnimation {
    CMHalfOpacityAnimation *animation = [CMHalfOpacityAnimation new];
    animation.toValue = @1.f;
    return animation;
}

+ (CMHalfOpacityAnimation *)opacityDownAnimation {
    CMHalfOpacityAnimation *animation = [CMHalfOpacityAnimation new];
    animation.toValue = @0.5f;
    return animation;
}

@end