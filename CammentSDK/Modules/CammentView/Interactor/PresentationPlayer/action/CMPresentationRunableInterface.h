//
// Created by Alexander Fedosov on 02.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionOutput.h"

@protocol CMPresentationRunableInterface <NSObject>

- (void)runWithOutput:(id<CMPresentationInstructionOutput>)output;

@end