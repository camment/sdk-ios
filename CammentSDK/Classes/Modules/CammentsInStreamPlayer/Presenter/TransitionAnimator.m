//
//  TransitionAnimator.m
//  EmbriaTest
//
//  Created by Alexander Fedosov on 17.09.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import "TransitionAnimator.h"
#import "CMShowsListViewController.h"
#import "CMCammentsInStreamPlayerViewController.h"
#import "POPBasicAnimation.h"
#import "NSArray+RacSequence.h"
#import <POP/POP.h>

@implementation TransitionAnimator

+ (TransitionAnimator *)animatorWithPresentingStatus:(BOOL)isPresenting{
    return [[TransitionAnimator alloc] initWithPresentingStatus:isPresenting];
}

- (instancetype)init{
    self = [self initWithPresentingStatus:NO];
    return self;
}

- (instancetype)initWithPresentingStatus:(BOOL)isPresenting{
    self = [super init];
    
    if (self) {
        _presenting = isPresenting;
    }
    
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return .2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    // get view controllers
    NSString *keyForViewController = self.presenting ? UITransitionContextFromViewControllerKey : UITransitionContextToViewControllerKey;
    NSString *keyForProfileViewController = self.presenting ? UITransitionContextToViewControllerKey : UITransitionContextFromViewControllerKey;
    CMShowsListViewController *showsListViewController = [(UINavigationController *)[transitionContext viewControllerForKey:keyForViewController] viewControllers].firstObject;
    CMCammentsInStreamPlayerViewController *streamPlayerViewController = [transitionContext viewControllerForKey:keyForProfileViewController];
    
    // setup viewcontrollers
    [showsListViewController.view setUserInteractionEnabled:NO];
    [streamPlayerViewController.view setUserInteractionEnabled:NO];
    [transitionContext.containerView addSubview:showsListViewController.view];
    [streamPlayerViewController.view setBackgroundColor:[UIColor clearColor]];

    // fade out to dark color view
    UIView *shadowView = [[UIView alloc] initWithFrame:showsListViewController.view.bounds];
    [transitionContext.containerView addSubview:shadowView];
    
    [transitionContext.containerView addSubview:streamPlayerViewController.view];
    
    // animate fade out to dark/fade in to clear color
    [self addAnimationForShadowView:shadowView];
    
    // add animation for top and bottom parts of presented screen
//    [self addAnimationToTopBar:streamPlayerViewController.topBar];
    [self addAnimationToInfoView:streamPlayerViewController.view];
    
    // add fake photo placeholder
    UIImageView *placeholderImageView = [UIImageView new];
    placeholderImageView.image = showsListViewController.selectedShowPlaceHolder;
    placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
    placeholderImageView.clipsToBounds = YES;
    [transitionContext.containerView addSubview:placeholderImageView];
    
    // add animation for photo
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    CGFloat height = streamPlayerViewController.view.bounds.size.width / 16 * 9;
    NSValue *shownRect = [NSValue valueWithCGRect:CGRectMake(
                                                             0,
                                                             (streamPlayerViewController.view.bounds.size.height - height) / 2,
                                                             streamPlayerViewController.view.bounds.size.width,
                                                             height)];
    NSValue *hiddenRect = [NSValue valueWithCGRect:showsListViewController.selectedCellFrame];
    animation.fromValue = self.presenting ? hiddenRect : shownRect;
    animation.toValue = self.presenting ? shownRect : hiddenRect;
    animation.duration = [self transitionDuration:transitionContext];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: self.presenting ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut];
    [animation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [streamPlayerViewController.view setBackgroundColor:[UIColor whiteColor]];
        [shadowView removeFromSuperview];
        [placeholderImageView removeFromSuperview];
        [showsListViewController.view setUserInteractionEnabled:YES];
        [streamPlayerViewController.view setUserInteractionEnabled:YES];
        [transitionContext completeTransition:YES];
    }];
    [placeholderImageView setFrame:[(NSValue *)animation.fromValue CGRectValue]];
    [placeholderImageView pop_addAnimation:animation forKey:@"frameAnimation"];

    placeholderImageView.clipsToBounds = YES;
    // add animation for corner radius
    POPBasicAnimation *radiusAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    radiusAnimation.fromValue = self.presenting ? @15 : @0;
    radiusAnimation.toValue = self.presenting ? @0 : @15;
    radiusAnimation.duration = [self transitionDuration:transitionContext];
    radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName: self.presenting ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut];
    [placeholderImageView.layer pop_addAnimation:radiusAnimation forKey:@"frameAnimation"];

    if (!self.presenting) {
        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];

        opacityAnimation.fromValue = @1;
        opacityAnimation.toValue = @0;
        opacityAnimation.duration = [self transitionDuration:nil] * 0.95;
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
        [placeholderImageView.layer pop_addAnimation:opacityAnimation forKey:@"frameAnimation"];
    }
}

- (void)addAnimationForShadowView:(UIView *)shadowView{
    POPBasicAnimation *shadowAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    UIColor *hiddenColor = [UIColor clearColor];
    UIColor *shownColor = [UIColor colorWithWhite:.2 alpha:.5];
    shadowAnim.fromValue = self.presenting ? hiddenColor : shownColor;
    shadowAnim.toValue = self.presenting ? shownColor : hiddenColor;
    shadowAnim.duration = [self transitionDuration:nil];
    [shadowView pop_addAnimation:shadowAnim forKey:@"backgroundColorAnimation"];
}

- (void)addAnimationToInfoView:(UIView *)profileInfoView{

    [profileInfoView.subviews map:^id(UIView  *value) {
        POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];

        animation.fromValue = self.presenting ? @0 : @1;
        animation.toValue = self.presenting ? @1 : @0;
        animation.duration = [self transitionDuration:nil] / 3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName: self.presenting ? kCAMediaTimingFunctionEaseIn : kCAMediaTimingFunctionEaseOut];
        [value.layer pop_addAnimation:animation forKey:@"frameAnimation"];
        return nil;
    }];
}

@end
