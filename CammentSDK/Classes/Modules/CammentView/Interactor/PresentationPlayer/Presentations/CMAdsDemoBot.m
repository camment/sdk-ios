//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMAdsDemoBot.h"
#import "CMPresentationInstructionOutput.h"
#import "CMBotAction.h"


@implementation CMAdsDemoBot {


}

- (NSString *)uuid {
    return kCMAdsDemoBotUUID;
}

- (BOOL)canRunAction:(CMBotAction *)action {
    return [action.action isEqualToString:kCMAdsDemoBotOpenURLAction];
}

- (void)runAction:(CMBotAction *)action {
    NSString *urlString = [(NSDictionary *)action.params valueForKey:kCMAdsDemoBotURLParam];
    if (urlString.length > 0) {
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        }
    }
}

- (void)setOutput:(id <CMPresentationInstructionOutput>)output {
    _output = output;
}

@end