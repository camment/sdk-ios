//
// Created by Alexander Fedosov on 01.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationActionInterface.h"


@interface CMDisplayAlertViewControllerPresentationAction : NSObject<CMPresentationActionInterface>

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message actions:(NSDictionary<NSString *, id <CMPresentationRunableInterface>> *)actions;

@end