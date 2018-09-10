//
// Created by Alexander Fedosov on 25.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/ASDisplayNode.h>
#import "CMHtmlShowCellNode.h"
#import "CMShow.h"


@interface CMHtmlShowCellNode ()
@property(nonatomic, strong) ASDisplayNode *htmlThumbnailNode;
@end

@implementation CMHtmlShowCellNode

- (instancetype)initWithShow:(CMShow *)show {
    self = [super initWithShow:show];
    if (self) {
        NSString *url = self.show.url;
        self.htmlThumbnailNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            return [UIWebView new];
        } didLoadBlock:^(__kindof ASDisplayNode *node) {
            [(UIWebView *)node.view loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
        }];
        self.htmlThumbnailNode.userInteractionEnabled = NO;
    }

    return self;
}

- (ASLayoutSpec *)contentNode {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_htmlThumbnailNode];
}

@end