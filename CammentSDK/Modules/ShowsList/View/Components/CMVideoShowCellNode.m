//
// Created by Alexander Fedosov on 25.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMVideoShowCellNode.h"
#import "CMShow.h"


@interface CMVideoShowCellNode ()
@property(nonatomic, strong) ASNetworkImageNode *videoThumbnailNode;
@end

@implementation CMVideoShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
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
        _videoThumbnailNode.contentMode = UIViewContentModeScaleAspectFill;
        _videoThumbnailNode.backgroundColor = [UIColor grayColor];
        [_videoThumbnailNode setURL:[[NSURL alloc] initWithString:self.show.thumbnail] resetToDefault:YES];
    }
}

- (ASDisplayNode *)contentNode {
    return _videoThumbnailNode;
}

@end