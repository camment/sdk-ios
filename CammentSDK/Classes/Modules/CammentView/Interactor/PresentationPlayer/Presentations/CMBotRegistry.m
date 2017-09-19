//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMBotRegistry.h"
#import "CMBot.h"
#import "CMBotAction.h"
#import "NSArray+RACSequenceAdditions.h"
#import "RACSequence.h"
#import "CMPresentationInstructionOutput.h"

@interface CMBotRegistry ()
@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;
@end

@implementation CMBotRegistry {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        _bots = [NSMutableArray new];
    }
    return self;
}

- (void)addBot:(id <CMBot>)bot {
    if ([self.bots containsObject:bot]) { return; }
    [bot setOutput:_output];
    [_bots addObject:bot];
}

- (void)removeBot:(id <CMBot>)bot {
    [_bots removeObject:bot];
}

- (void)runAction:(CMBotAction *)action {
    [[_bots.rac_sequence map:^id(id <CMBot> bot) {
        if ([[bot uuid] isEqualToString:action.botUuid] && [bot canRunAction:action]) {
            [bot runAction:action];
        }
        return nil;
    }] array];
}

- (void)updateBotsOutputInterface:(id <CMPresentationInstructionOutput>)output {
    self.output = output;
    [[_bots.rac_sequence map:^id(id <CMBot> bot) {
        [bot setOutput:output];
        return nil;
    }] array];
}


@end
