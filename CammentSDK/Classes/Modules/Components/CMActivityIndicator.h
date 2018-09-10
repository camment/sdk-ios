//
//  CMActivityIndicator.h
//  Camment OY
//
//  Created by Alexander Fedosov on 02.08.15.
//  Copyright (c) 2015 Alexander Fedosov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMActivityIndicator : UIView

@property(nonatomic, strong) IBInspectable UIImage *image;
@property(nonatomic, assign) IBInspectable BOOL animateAfterLoad;

- (void)startAnimation;

- (void)stopAnimation;

- (BOOL)isAnimating;

@end
