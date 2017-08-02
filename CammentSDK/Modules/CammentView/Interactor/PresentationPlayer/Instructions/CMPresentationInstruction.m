//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPresentationInstruction.h"
#import "CMPresentationState.h"
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationActionInterface.h"


@implementation CMPresentationInstruction

- (instancetype)init {
    self = [super init];
    if (self) {
        self.enabled = YES;
    }

    return self;
}


- (BOOL)shouldBeTriggeredForState:(CMPresentationState *)state {
    return (!_wasTriggered || _shouldTriggerEveryTick) && _enabled;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    self.wasTriggered = YES;
}

@end
