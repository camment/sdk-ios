//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPresentationInstruction.h"
#import "CMPresentationState.h"
#import "CMPresentationInstructionOutput.h"


@implementation CMPresentationInstruction

- (BOOL)shouldBeTriggeredForState:(CMPresentationState *)state {
    return !_wasTriggered || _shouldTriggerEveryTick;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    self.wasTriggered = YES;
}

@end
