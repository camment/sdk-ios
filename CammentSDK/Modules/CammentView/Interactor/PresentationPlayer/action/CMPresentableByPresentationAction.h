//
// Created by Alexander Fedosov on 02.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationRunableInterface.h"

@protocol CMPresentableByPresentationAction <NSObject>

- (void)presentWithOutput:(id <CMPresentationInstructionOutput>)output actions:(NSDictionary<NSString *, NSArray<id <CMPresentationRunableInterface>> *> *)actions;

@end