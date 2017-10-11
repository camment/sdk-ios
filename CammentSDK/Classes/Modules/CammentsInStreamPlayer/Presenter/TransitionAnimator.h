//
//  TransitionAnimator.h
//  EmbriaTest
//
//  Created by Alexander Fedosov on 17.09.15.
//  Copyright © 2015 Alexander Fedosov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) BOOL presenting;

- (instancetype)initWithPresentingStatus:(BOOL)isPresenting NS_DESIGNATED_INITIALIZER;

+ (TransitionAnimator *)animatorWithPresentingStatus:(BOOL)isPresenting;

@end
