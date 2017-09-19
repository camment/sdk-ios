//
// Created by Alexander Fedosov on 25.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMVideoShowCellNode.h"
#import "CMShow.h"


@interface CMVideoShowCellNode ()
@property(nonatomic, strong) ASVideoNode *videoThumbnailNode;
@end

@implementation CMVideoShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
    self = [super initWithShow:show];
    if (self) {
        self.videoThumbnailNode = [ASVideoNode new];
        self.videoThumbnailNode.enabled = NO;
        self.videoThumbnailNode.gravity = AVLayerVideoGravityResizeAspectFill;
    }

    return self;
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];

    _videoThumbnailNode.contentMode = UIViewContentModeScaleAspectFill;
    _videoThumbnailNode.backgroundColor = [UIColor grayColor];
    
    BOOL hasThumbnails = self.show.thumbnail != nil;
    NSString *previewURL = hasThumbnails ? self.show.thumbnail : self.show.url;
    if (!previewURL) { return; }
    
    NSURL *url = [[NSURL alloc] initWithString:previewURL];
    if (!url) { return;}

    if (hasThumbnails) {
        [_videoThumbnailNode setURL:url resetToDefault:YES];
    } else {
        [_videoThumbnailNode setAssetURL:url];
    }
}

- (ASDisplayNode *)contentNode {
    return _videoThumbnailNode;
}

@end
