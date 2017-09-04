//
// Created by Alexander Fedosov on 16.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMWebContentPlayerNode.h"

@interface CMWebContentPlayerNode ()
@property(nonatomic, strong) ASDisplayNode *webViewNode;
@end

@implementation CMWebContentPlayerNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.webViewNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
            UIWebView *webview = [UIWebView new];
            return webview;
        } didLoadBlock:^(__kindof ASDisplayNode *node) {

        }];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)openContentAtUrl:(NSURL *)url {
    [(UIWebView *)self.webViewNode.view loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f)
                                                  child:_webViewNode];
}

@end