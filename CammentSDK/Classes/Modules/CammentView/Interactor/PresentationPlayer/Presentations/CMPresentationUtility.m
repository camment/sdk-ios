//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPresentationUtility.h"
#import "CMCammentsBlockItem.h"
#import "CMPresentationBuilder.h"
#import "CMWoltPresentationBuilder.h"
#import "CMNetflixPresentationBuilder.h"
#import "CMSBPresentationBuilder.h"
#import "CMCammentBuilder.h"
#import "CMEmailSubscriptionPresentationBuilder.h"
#import "CMBettingPresentationBuilder.h"
#import "CMAdsDemoBot.h"
#import "CMBotAction.h"
#import "CMVideoAdPresentationBuilder.h"
#import "CMTontonPresentationBuilder.h"

NSString *const kCMPresentationBuilderUtilityAnyShowUUID = @"any";

@implementation CMPresentationUtility {

}
+ (NSArray<id <CMPresentationBuilder>> *)activePresentations {
    return @[
            [CMWoltPresentationBuilder new],
            [CMNetflixPresentationBuilder new],
            [CMSBPresentationBuilder new],
            [CMEmailSubscriptionPresentationBuilder new],
            [CMBettingPresentationBuilder new],
            [CMVideoAdPresentationBuilder new],
            [CMTontonPresentationBuilder new]
    ];
}

- (CMCammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url {
    CMBotAction *action = [CMBotAction new];
    action.botUuid = kCMAdsDemoBotUUID;
    action.action = kCMAdsDemoBotOpenURLAction;
    action.params = @{
            kCMAdsDemoBotURLParam: url ?: @""
    };
    CMBotCamment *cmBotCamment = [self botCammentWithLocalGif:filename action:action];
    return [CMCammentsBlockItem botCammentWithBotCamment:cmBotCamment];
}

- (CMCammentsBlockItem *)blockItemBotAction:(NSString *)filename action:(CMBotAction *)action{
    CMBotCamment *cmBotCamment = [self botCammentWithLocalGif:filename action:action];
    return [CMCammentsBlockItem botCammentWithBotCamment:cmBotCamment];
}

- (CMBotCamment *)botCammentWithLocalGif:(NSString *)filename action:(CMBotAction *)action {
    NSString *filepath = [[NSBundle cammentSDKBundle] pathForResource:filename ofType:@"gif"];
    NSURL *pathUrl = [NSURL fileURLWithPath:filepath];
    return [[CMBotCamment alloc] initWithURL:pathUrl.absoluteString
                                   botAction:action];
}

- (CMCammentsBlockItem *)blockItemCammentWithLocalVideo:(NSString *)filename {
    CMCamment *camment = [self cammentWithLocalVideo:filename];
    return [CMCammentsBlockItem cammentWithCamment:camment];
}

- (CMCamment *)cammentWithLocalVideo:(NSString *)filename {
    NSString *filepath = [[NSBundle cammentSDKBundle] pathForResource:filename ofType:@"mp4"];
    CMCamment *camment = [[[[[CMCammentBuilder new]
            withShowUuid:kCMPresentationBuilderUtilityAnyShowUUID]
            withUuid:[NSUUID new].UUIDString.lowercaseString]
            withLocalURL:filepath] build];
    return camment;
}

- (CMDisplayCammentPresentationAction *)displayCammentActionWithLocalVideo:(NSString *)filename {
    CMCammentsBlockItem *blockItem = [self blockItemCammentWithLocalVideo:filename];
    return [[CMDisplayCammentPresentationAction alloc] initWithItem:blockItem];
}

- (CMDisplayCammentPresentationAction *)displayCammentActionWithLocalGif:(NSString *)filename url:(NSString *)url {
    CMCammentsBlockItem *blockItem = [self blockItemAdsWithLocalGif:filename url:url];
    return [[CMDisplayCammentPresentationAction alloc] initWithItem:blockItem];
}

- (CMDisplayCammentPresentationAction *)displayBotActionWithLocalGif:(NSString *)filename action:(CMBotAction *)action {
    CMCammentsBlockItem *blockItem = [self blockItemBotAction:filename action:action];
    return [[CMDisplayCammentPresentationAction alloc] initWithItem:blockItem];
}

@end
