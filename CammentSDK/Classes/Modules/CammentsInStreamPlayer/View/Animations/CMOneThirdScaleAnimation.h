//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/POP.h>


@interface CMOneThirdScaleAnimation: POPSpringAnimation
+ (CMOneThirdScaleAnimation *)scaleUpAnimation;

+ (CMOneThirdScaleAnimation *)scaleDownAnimation;
@end