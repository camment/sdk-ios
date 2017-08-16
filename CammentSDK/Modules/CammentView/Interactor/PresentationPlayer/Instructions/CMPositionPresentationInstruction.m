//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPositionPresentationInstruction.h"
#import "CMPresentationState.h"
#import "CMPresentationInstructionOutput.h"
#import "CMCammentsBlockItem.h"

@implementation CMPositionPresentationInstruction

- (instancetype)initWithPosition:(NSUInteger)position action:(id <CMPresentationActionInterface>)action {
    self = [super init];

    if (self) {
        self.position = position;
        self.action = action;
    }

    return self;
}

- (instancetype)initWithPosition:(NSUInteger)position action:(id <CMPresentationActionInterface>)action delay:(NSTimeInterval)delay {
    self = [self initWithPosition:position action:action];
    if (self) {
        self.delay = delay;
    }
    
    return self;
}

- (BOOL)shouldBeTriggeredForState:(CMPresentationState *)state {
    BOOL shouldTriggered = (state.items.count + 1) == _position;
    return [super shouldBeTriggeredForState:state] && shouldTriggered;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    [super runWithOutput:output];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(self.delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.action runWithOutput:output];
    });
}

@end
