//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMAdsCell.h"
#import "Ads.h"
#import "CMAdsNode.h"
#import "UIColorMacros.h"


@interface CMAdsCell ()
@property(nonatomic, strong) CMAdsNode* adsNode;
@end

@implementation CMAdsCell

- (instancetype)initWithAds:(Ads *)ads {
    self = [super init];
    if (self) {
        self.adsNode = [[CMAdsNode alloc] initWithAds:ads];
        self.borderColor = UIColorFromRGB(0x3B3B3B).CGColor;
        self.borderWidth = 2.0f;
        self.cornerRadius = 4.0f;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.adsNode.style.preferredSize = CGSizeMake(
            45.0f,
            45.0f);
    ASWrapperLayoutSpec *layoutSpec = [ASWrapperLayoutSpec wrapperWithLayoutElement:_adsNode];
    return layoutSpec;
}

@end