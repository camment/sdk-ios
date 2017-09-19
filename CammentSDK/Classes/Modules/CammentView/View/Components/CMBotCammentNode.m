//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMBotCammentNode.h"
#import "CMBotCamment.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <AsyncDisplayKit/ASPINRemoteImageDownloader.h>

@interface CMBotCammentNode ()

@property(nonatomic, strong) CMBotCamment *ads;
@property(nonatomic, strong) ASNetworkImageNode *adsPlayerNode;
@property(nonatomic, strong) ASPINRemoteImageDownloader *downloader;

@end

@implementation CMBotCammentNode

- (instancetype)initWithAds:(CMBotCamment *)ads {
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
    ASRatioLayoutSpec *cammentBlockSpec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0f
                                                                                child:_adsPlayerNode];
    ASInsetLayoutSpec *layoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                           child:cammentBlockSpec];
    return layoutSpec;
}


@end
