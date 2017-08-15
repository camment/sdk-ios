//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMShowCellNode.h"
#import "CMAPIShow.h"
#import "Show.h"

@implementation CMShowCellNode

- (instancetype)initWithShow:(Show *)show {
    self = [super init];
    if (self) {
        _show = show;

        self.clipsToBounds = YES;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASDisplayNode *)contentNode {
    return [ASDisplayNode new];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASDisplayNode *contentNode = [self contentNode];
    contentNode.style.preferredLayoutSize = ASLayoutSizeMake(ASDimensionMakeWithFraction(1), ASDimensionMakeWithFraction(1));

    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                child:[ASStackLayoutSpec
                                        stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                             spacing:4.0f
                                                      justifyContent:ASStackLayoutJustifyContentSpaceBetween
                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                            children:@[contentNode]]];
}

@end
