//
//  CMDisplayNode.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 10/09/2018.
//

#import "CMDisplayNode.h"

@implementation CMDisplayNode

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationUnknown) { return; }
    if (UIEdgeInsetsEqualToEdgeInsets(self.safeAreaInsets, UIEdgeInsetsZero)) { return; }
    
    self.calculatedSafeAreaInsets = UIEdgeInsetsMake(
                                                     self.safeAreaInsets.top,
                                                     orientation == UIInterfaceOrientationLandscapeRight ? self.safeAreaInsets.left : .0f,
                                                     self.safeAreaInsets.bottom,
                                                     orientation == UIInterfaceOrientationLandscapeLeft? self.safeAreaInsets.right : .0f);
    [self setNeedsLayout];
    [self transitionLayoutWithAnimation:YES
                     shouldMeasureAsync:NO
                  measurementCompletion:^{}];
}

@end
