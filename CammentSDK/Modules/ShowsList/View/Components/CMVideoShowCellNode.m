//
// Created by Alexander Fedosov on 25.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMVideoShowCellNode.h"
#import "Show.h"


@interface CMVideoShowCellNode ()
@property(nonatomic, strong) ASVideoNode *videoThumbnailNode;
@end

@implementation CMVideoShowCellNode

- (instancetype)initWithShow:(Show *)show {
    self = [super initWithShow:show];
    if (self) {
        self.videoThumbnailNode = [ASVideoNode new];
        self.videoThumbnailNode.enabled = NO;
    }

    return self;
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];

    NSURL *url = [[NSURL alloc] initWithString:self.show.url];
    if (url) {
        _videoThumbnailNode.gravity = AVLayerVideoGravityResizeAspectFill;
        _videoThumbnailNode.backgroundColor = [UIColor grayColor];
        _videoThumbnailNode.asset = [AVAsset assetWithURL:url];
    }
}

- (ASDisplayNode *)contentNode {
    return _videoThumbnailNode;
}

@end