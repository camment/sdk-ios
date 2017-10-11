//
//  TransitionDelegate.m
//  EmbriaTest
//
//  Created by Alexander Fedosov on 17.09.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import "TransitionDelegate.h"
#import "TransitionAnimator.h"

@implementation TransitionDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [TransitionAnimator animatorWithPresentingStatus:YES];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [TransitionAnimator animatorWithPresentingStatus:NO];
}

@end
