//
// Created by Alexander Fedosov on 07.02.2018.
// Copyright (c) 2018 Sportacam. All rights reserved.
//

#import "CMTouchTransparentView.h"


@implementation CMTouchTransparentView {

}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end