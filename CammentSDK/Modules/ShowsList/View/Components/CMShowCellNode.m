//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMShowCellNode.h"
#import "CMShow.h"


@interface CMShowCellNode ()
@property(nonatomic, strong) ASNetworkImageNode *showThumbnailNode;
@property(nonatomic, strong) ASTextNode *titleTextNode;
@end

@implementation CMShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];
    if (self) {
        _show = show;

        self.showThumbnailNode = [ASNetworkImageNode new];
        NSURL *url = [[NSURL alloc] initWithString:show.url];
        if (url) {
            _showThumbnailNode.URL = url;
        }

        self.titleTextNode = [ASTextNode new];
        self.titleTextNode.attributedText = [[NSAttributedString alloc] initWithString:show.url];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                child:[ASStackLayoutSpec
                                        stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                             spacing:4.0f
                                                      justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                            children:@[_showThumbnailNode, _titleTextNode]]];
}

@end