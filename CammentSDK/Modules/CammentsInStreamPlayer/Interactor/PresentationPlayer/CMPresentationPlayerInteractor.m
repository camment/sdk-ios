//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPresentationPlayerInteractor.h"
#import "CMCammentsInStreamPlayerInteractorOutput.h"
#import "CMPresentationState.h"
#import "CMPresentationInstructionInterface.h"
#import "CMPresentationInstructionOutput.h"


@implementation CMPresentationPlayerInteractor

- (void)update:(CMPresentationState *)state {
    for (id<CMPresentationInstructionInterface> instruction in _instructions) {
        if ([instruction shouldTriggeredForState:state]) {
            [instruction runWithOutput:self.instructionOutput];
        }
    }
}


@end