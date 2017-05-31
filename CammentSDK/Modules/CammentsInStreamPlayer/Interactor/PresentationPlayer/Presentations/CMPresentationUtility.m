//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMPresentationUtility.h"
#import "CammentsBlockItem.h"


@implementation CMPresentationUtility {

}
- (CammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url {
    NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:filename ofType:@"gif"];
    NSURL *pathUrl = [NSURL fileURLWithPath:filepath];
    CammentsBlockItem *ads = [CammentsBlockItem adsWithAds:[[Ads alloc] initWithURL:pathUrl.absoluteString
                                                                            openURL:url]];
    return ads;
}

@end