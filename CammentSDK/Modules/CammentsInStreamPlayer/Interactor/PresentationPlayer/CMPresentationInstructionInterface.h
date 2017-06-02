//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationState.h"

@protocol CMPresentationInstructionInterface <NSObject>

- (BOOL)shouldBeTriggeredForState:(CMPresentationState *)state;
- (void)runWithOutput:(id<CMPresentationInstructionOutput>)output;

@end
