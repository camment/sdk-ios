//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMAdsNode.h"
#import "CMAds.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <AsyncDisplayKit/ASPINRemoteImageDownloader.h>

@interface CMAdsNode ()

@property(nonatomic, strong) CMAds *ads;
@property(nonatomic, strong) ASNetworkImageNode *adsPlayerNode;
@property(nonatomic, strong) ASPINRemoteImageDownloader *downloader;

@end

@implementation CMAdsNode

- (instancetype)initWithAds:(CMAds *)ads {
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
