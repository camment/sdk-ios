//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMAdsNode.h"
#import "Ads.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <Texture/AsyncDisplayKit/ASPINRemoteImageDownloader.h>

@interface CMAdsNode ()

@property(nonatomic, strong) Ads *ads;
@property(nonatomic, strong) ASNetworkImageNode *adsPlayerNode;
@property(nonatomic, strong) ASPINRemoteImageDownloader *downloader;

@end

@implementation CMAdsNode

- (instancetype)initWithAds:(Ads *)ads {
    self = [super init];
    if (self) {

        self.ads = ads;
        self.downloader = [[ASPINRemoteImageDownloader alloc] init];
        self.adsPlayerNode = [[ASNetworkImageNode alloc] initWithCache:nil
                                                            downloader:self.downloader];
        self.adsPlayerNode.shouldCacheImage = NO;
        self.adsPlayerNode.URL = [[NSURL alloc] initWithString:ads.URL];
        
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *layoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                           child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0f
                                                                                                                       child:_adsPlayerNode]];
    return layoutSpec;
}


@end
