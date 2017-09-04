//
// Created by Alexander Fedosov on 29.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIViewController (topVisibleViewController)


+ (UIViewController *)topViewController;

- (UIViewController *)topVisibleViewController;
@end