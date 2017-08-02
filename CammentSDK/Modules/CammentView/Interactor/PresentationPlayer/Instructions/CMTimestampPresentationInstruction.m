//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMTimestampPresentationInstruction.h"
#import "CammentsBlockItem.h"
#import "CMPresentationState.h"
#import "CMPresentationInstructionOutput.h"

@implementation CMTimestampPresentationInstruction

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp action:(id <CMPresentationActionInterface>)action {
    self = [super init];

    if (self) {
        self.timestamp = timestamp;
        self.action = action;
    }

    return self;
}

- (BOOL)shouldBeTriggeredForState:(CMPresentationState *)state {
    BOOL shouldTriggered = state.timestamp >= self.timestamp;
    return [super shouldBeTriggeredForState:state] && shouldTriggered;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    [super runWithOutput:output];
    [self.action runWithOutput:output];
}


@end
