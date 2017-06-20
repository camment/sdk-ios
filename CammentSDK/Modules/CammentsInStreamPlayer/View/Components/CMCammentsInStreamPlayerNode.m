//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMCammentsInStreamPlayerNode.h"
#import "CMVideoContentPlayerNode.h"
#import "CMWebContentPlayerNode.h"
#import "CMCammentsOverlayViewNode.h"
#import "CMCammentOverlayController.h"


@implementation CMCammentsInStreamPlayerNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)setContentType:(enum CMContentType)contentType {
    switch (contentType) {
        case CMContentTypeVideo:
            self.contentViewerNode = [CMVideoContentPlayerNode new];
            break;
        case CMContentTypeHTML:
            self.contentViewerNode = [CMWebContentPlayerNode new];
            break;
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.style.width = ASDimensionMake(constrainedSize.max.width);
    self.style.height = ASDimensionMake(constrainedSize.max.height);

    ASDisplayNode *childNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * {
        return self.cammentsOverlayView ?: [UIView new];
    }];
    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                                child:childNode];
    return insetLayoutSpec;
}

@end