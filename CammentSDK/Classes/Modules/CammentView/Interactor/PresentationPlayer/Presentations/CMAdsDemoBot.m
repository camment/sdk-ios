//
// Created by Alexander Fedosov on 19.09.17.
//

#import "CMAdsDemoBot.h"
#import "CMPresentationInstructionOutput.h"
#import "CMBotAction.h"
#import "CMVideoAd.h"
#import "CammentSDK.h"
#import "CMOpenURLHelper.h"
#import "CMPresentationRunableInterface.h"
#import "CMPresentationInstructionInterface.h"

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
                [[CMOpenURLHelper new] openURL:url];
            }
        }
    }

    if ([action.action isEqualToString:kCMAdsDemoBotPlayVideoAction]) {
        NSString *videoUrlString = [(NSDictionary *)action.params valueForKey:kCMAdsDemoBotVideoURLParam];
        NSString *placeholderUrlString = [(NSDictionary *)action.params valueForKey:kCMAdsDemoBotPlaceholderURLParam];
        NSValue *rectValue = [(NSDictionary *) action.params valueForKey:kCMAdsDemoBotRectParam];
        CGRect startingFromRect =  [rectValue CGRectValue];

        NSURL *videoUrl = nil;

        if (videoUrlString) {
            videoUrl = [[NSURL alloc] initWithString:videoUrlString];
        }

        NSURL *placeholderURL = nil;
        if (placeholderUrlString) {
            placeholderURL = [[NSURL alloc] initWithString:placeholderUrlString];
        }

        CMVideoAd *videoAd = [[CMVideoAd alloc] initWithVideoURL:videoUrl
                                                         linkUrl:url
                                                  placeholderURL:placeholderURL];

        id<CMPresentationInstructionInterface> instruction = [(NSDictionary *)action.params
                valueForKey:kCMAdsDemoBotVideoOnClickPresentationInstructionParam];
        if (instruction) {
            videoAd.onClickAction = ^{
                [instruction runWithOutput:self.output];
            };
        }

        [self.output presentationInstruction:nil
                                playVideoAds:videoAd
                        playStartingFromRect:startingFromRect];
    }
}

- (void)setOutput:(id <CMPresentationInstructionOutput>)output {
    _output = output;
}

@end
