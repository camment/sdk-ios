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

NSString * const kCMPresentationBuilderUtilityAnyShowUUID = @"any";

@implementation CMPresentationUtility {

}
+ (NSArray<id <CMPresentationBuilder>> *)activePresentations {
    return @[
            [CMWoltPresentationBuilder new],
            [CMNetflixPresentationBuilder new],
            [CMSBPresentationBuilder new],
            [CMEmailSubscriptionPresentationBuilder new]
    ];
}

- (CMCammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url {
    NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"gif"];
    NSURL *pathUrl = [NSURL fileURLWithPath:filepath];
    CMCammentsBlockItem *ads = [CMCammentsBlockItem adsWithAds:[[CMAds alloc] initWithURL:pathUrl.absoluteString
                                                                            openURL:url]];
    return ads;
}

- (CMCammentsBlockItem *)blockItemCammentWithLocalVideo:(NSString *)filename {
    NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"mp4"];
    CMCamment *camment = [[[[[CMCammentBuilder new]
            withShowUuid:kCMPresentationBuilderUtilityAnyShowUUID]
            withUuid:[NSUUID new].UUIDString.lowercaseString]
            withLocalURL:filepath] build];
    return [CMCammentsBlockItem cammentWithCamment:camment];
}

- (CMDisplayCammentPresentationAction *)displayCammentActionWithLocalVideo:(NSString *)filename {
    CMCammentsBlockItem *blockItem = [self blockItemCammentWithLocalVideo:filename];
    return [[CMDisplayCammentPresentationAction alloc] initWithItem:blockItem];
}

- (CMDisplayCammentPresentationAction *)displayCammentActionWithLocalGif:(NSString *)filename url:(NSString *)url {
    CMCammentsBlockItem *blockItem = [self blockItemAdsWithLocalGif:filename url:url];
    return [[CMDisplayCammentPresentationAction alloc] initWithItem:blockItem];
}

@end