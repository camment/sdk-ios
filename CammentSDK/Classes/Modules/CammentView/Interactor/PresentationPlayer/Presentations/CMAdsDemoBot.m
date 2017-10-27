//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMAdsDemoBot.h"
#import "CMPresentationInstructionOutput.h"
#import "CMBotAction.h"
#import "CMVideoAd.h"


@implementation CMAdsDemoBot {


}

- (NSString *)uuid {
    return kCMAdsDemoBotUUID;
}

- (BOOL)canRunAction:(CMBotAction *)action {
    return [action.action isEqualToString:kCMAdsDemoBotOpenURLAction]
            || [action.action isEqualToString:kCMAdsDemoBotPlayVideoAction];
}

- (void)runAction:(CMBotAction *)action {
    NSString *urlString = [(NSDictionary *)action.params valueForKey:kCMAdsDemoBotURLParam];
    NSURL *url = [[NSURL alloc] initWithString:urlString];

    if ([action.action isEqualToString:kCMAdsDemoBotOpenURLAction]) {
        if (urlString.length > 0) {

            if (url && [[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
            }
        }
    }

    if ([action.action isEqualToString:kCMAdsDemoBotPlayVideoAction]) {
        NSString *videoUrlString = [(NSDictionary *)action.params valueForKey:kCMAdsDemoBotVideoURLParam];
        NSURL *videoUrl = [[NSURL alloc] initWithString:videoUrlString];
        NSValue *rectValue = [(NSDictionary *) action.params valueForKey:kCMAdsDemoBotRectParam];
        CGRect startingFromRect =  [rectValue CGRectValue];
        [self.output presentationInstruction:nil
                                playVideoAds:[[CMVideoAd alloc] initWithVideoURL:videoUrl linkUrl:url]
                        playStartingFromRect:startingFromRect];
    }
}

- (void)setOutput:(id <CMPresentationInstructionOutput>)output {
    _output = output;
}

@end