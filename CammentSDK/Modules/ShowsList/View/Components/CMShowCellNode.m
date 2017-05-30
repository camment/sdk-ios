//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMShowCellNode.h"
#import "CMShow.h"


@interface CMShowCellNode ()
@property(nonatomic, strong) ASVideoNode *videoThumbnailNode;
@property(nonatomic, strong) ASTextNode *titleTextNode;
@end

@implementation CMShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        _show = show;

        self.videoThumbnailNode = [ASVideoNode new];
        self.videoThumbnailNode.enabled = NO;
        self.titleTextNode = [ASTextNode new];
        self.titleTextNode.attributedText = [[NSAttributedString alloc] initWithString:show.url];
        self.neverShowPlaceholders = YES;
        self.displaysAsynchronously = NO;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];

    NSURL *url = [[NSURL alloc] initWithString:_show.url];
    if (url) {
        _videoThumbnailNode.gravity = AVLayerVideoGravityResizeAspectFill;
        _videoThumbnailNode.backgroundColor = [UIColor grayColor];
        _videoThumbnailNode.asset = [AVAsset assetWithURL:url];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.videoThumbnailNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMakeWithFraction(1), ASDimensionMakeWithFraction(1));
    
    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 4, 4, 4)
                                child:[ASStackLayoutSpec
                                        stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                             spacing:4.0f
                                                      justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                            children:@[_videoThumbnailNode, _titleTextNode]]];
}

@end
