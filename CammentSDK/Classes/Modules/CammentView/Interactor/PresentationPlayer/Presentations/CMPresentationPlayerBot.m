//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMPresentationPlayerBot.h"
#import "CMPresentationInstructionInterface.h"
#import "CMBotAction.h"


@implementation CMPresentationPlayerBot {

}

- (NSString *)uuid {
    return kCMPresentationPlayerBotUUID;
}

- (BOOL)canRunAction:(CMBotAction *)action {
    return (self.output != nil && action.action == kCMPresentationPlayerBotPlayAction);
}

- (void)runAction:(CMBotAction *)action {
    id<CMPresentationInstructionInterface> instruction = [action.params valueForKey:kCMPresentationPlayerBotRunableParam];
    if (instruction) {
        [instruction runWithOutput:self.output];
    }
}

- (void)setOutput:(id <CMPresentationInstructionOutput>)output {
    _output = output;
}

@end