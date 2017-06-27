//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPresentationUtility.h"
#import "CammentsBlockItem.h"
#import "CMPresentationBuilder.h"
#import "CMWoltPresentationBuilder.h"
#import "CMNetflixPresentationBuilder.h"
#import "CMSBPresentationBuilder.h"
#import "CammentBuilder.h"

NSString * const kCMPresentationBuilderUtilityAnyShowUUID = @"any";

@implementation CMPresentationUtility {

}
+ (NSArray<id <CMPresentationBuilder>> *)activePresentations {
    return @[
            [CMWoltPresentationBuilder new],
            [CMNetflixPresentationBuilder new],
            [CMSBPresentationBuilder new]
    ];
}

- (CammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url {
    NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"gif"];
    NSURL *pathUrl = [NSURL fileURLWithPath:filepath];
    CammentsBlockItem *ads = [CammentsBlockItem adsWithAds:[[Ads alloc] initWithURL:pathUrl.absoluteString
                                                                            openURL:url]];
    return ads;
}

- (CammentsBlockItem *)blockItemCammentWithLocalVideo:(NSString *)filename {
    NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"mp4"];
    Camment *camment = [[[[[CammentBuilder new]
            withShowUUID:kCMPresentationBuilderUtilityAnyShowUUID]
            withUuid:[NSUUID new].UUIDString.lowercaseString]
            withLocalURL:filepath] build];
    return [CammentsBlockItem cammentWithCamment:camment];
}


@end