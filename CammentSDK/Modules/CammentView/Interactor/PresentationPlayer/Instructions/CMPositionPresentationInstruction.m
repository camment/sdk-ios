//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPositionPresentationInstruction.h"
#import "CMPresentationState.h"
#import "CMPresentationInstructionOutput.h"
#import "CammentsBlockItem.h"

@implementation CMPositionPresentationInstruction

- (instancetype)initWithPosition:(NSUInteger)position item:(CammentsBlockItem *)item {
    self = [super init];

    if (self) {
        self.position = position;
        self.item = item;
    }

    return self;
}

- (instancetype)initWithPosition:(NSUInteger)position item:(CammentsBlockItem *)item delay:(NSTimeInterval)delay {
    self = [self initWithPosition:position item:item];
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
        [self.item matchCamment:^(Camment *camment) {
            [output didReceiveNewCamment:camment];
        } ads:^(Ads *ads) {
            [output didReceiveNewAds:ads];
        }];
    });
}

@end
