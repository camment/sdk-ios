//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMAdsCell.h"
#import "CMAds.h"
#import "CMAdsNode.h"
#import "UIColorMacros.h"


@interface CMAdsCell ()
@property(nonatomic, strong) CMAdsNode* adsNode;
@property(nonatomic, strong) ASTextNode* adsTextNode;
@property(nonatomic, strong) ASButtonNode *closeButtonNode;
@end

@implementation CMAdsCell

- (instancetype)initWithAds:(CMAds *)ads {
    self = [super init];
    if (self) {
        self.ads = ads;
        self.adsNode = [[CMAdsNode alloc] initWithAds:ads];
        
        self.closeButtonNode = [ASButtonNode new];
        [self.closeButtonNode setImage:[UIImage imageNamed:@"close_ads_button"
                                                  inBundle:[NSBundle bundleForClass:[self class]]
                             compatibleWithTraitCollection:nil]
                              forState:UIControlStateNormal];
        [self.closeButtonNode addTarget:self
                                 action:@selector(didTapOnCloseButton)
                       forControlEvents:ASControlNodeEventTouchUpInside];
        
        self.adsTextNode = [ASTextNode new];
        self.adsTextNode.maximumNumberOfLines = 1;
        self.adsTextNode.shadowOpacity = 1.0f;
        self.adsTextNode.shadowColor = UIColor.blackColor.CGColor;
        self.adsTextNode.shadowOffset = CGSizeMake(.0f, .0f);
        [self.adsTextNode setAttributedText:[[NSAttributedString alloc] initWithString:@"AD"
                                                                            attributes:@{
                                                                                         NSFontAttributeName: [UIFont systemFontOfSize:9.0f],
                                                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                         }]];
        self.adsNode.borderColor = UIColorFromRGB(0x3B3B3B).CGColor;
        self.adsNode.borderWidth = 2.0f;
        self.adsNode.cornerRadius = 4.0f;
        self.adsNode.clipsToBounds = YES;
        
        self.clipsToBounds = NO;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.adsNode.style.preferredSize = CGSizeMake(45.0f, 45.0f);
    self.adsNode.style.layoutPosition = CGPointMake(.0f, .0f);
    
    self.closeButtonNode.style.preferredSize = CGSizeMake(30, 30);
    self.closeButtonNode.style.layoutPosition = CGPointMake(-15.0f, -12.0f);
    
    self.adsTextNode.style.width = ASDimensionMake(30.0f);
    self.adsTextNode.style.height = ASDimensionMake(30.0f);
    self.adsTextNode.style.layoutPosition = CGPointMake(45.0f, 0.0f);
    
    ASAbsoluteLayoutSpec *absoluteLayoutSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingSizeToFit children:@[_adsNode, _closeButtonNode, _adsTextNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, -40.0f) child:absoluteLayoutSpec];
}

- (void)didTapOnCloseButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(adsCellDidTapOnCloseButton:)]) {
        [self.delegate adsCellDidTapOnCloseButton:self];
    }
}

@end
