//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMBotCammentCell.h"
#import "CMBotCamment.h"
#import "CMBotCammentNode.h"
#import "UIColorMacros.h"
#import "CMAdsDemoBot.h"


@interface CMBotCammentCell ()
@property(nonatomic, strong) CMBotCammentNode* botCammentNode;
@property(nonatomic, strong) ASTextNode* adsTextNode;
@property(nonatomic, strong) ASButtonNode *closeButtonNode;
@end

@implementation CMBotCammentCell

- (instancetype)initWithBotCamment:(CMBotCamment *)botCamment {
    self = [super init];
    if (self) {
        self.botCamment = botCamment;
        self.botCammentNode = [[CMBotCammentNode alloc] initWithAds:botCamment];
        
        self.closeButtonNode = [ASButtonNode new];
        [self.closeButtonNode setImage:[UIImage imageNamed:@"close_ads_button"
                                                  inBundle:[NSBundle cammentSDKBundle]
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
#warning make it better
        NSString *cellTag = botCamment.botAction.botUuid == kCMAdsDemoBotUUID ? @"AD" : @"BOT";
        [self.adsTextNode setAttributedText:[[NSAttributedString alloc] initWithString:cellTag
                                                                            attributes:@{
                                                                                         NSFontAttributeName: [UIFont systemFontOfSize:9.0f],
                                                                                         NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                         }]];
        self.botCammentNode.borderColor = UIColorFromRGB(0x3B3B3B).CGColor;
        self.botCammentNode.borderWidth = 2.0f;
        self.botCammentNode.cornerRadius = 4.0f;
        self.botCammentNode.clipsToBounds = YES;
        
        self.clipsToBounds = NO;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.botCammentNode.style.preferredSize = CGSizeMake(45.0f, 45.0f);
    self.botCammentNode.style.layoutPosition = CGPointMake(.0f, .0f);
    
    self.closeButtonNode.style.preferredSize = CGSizeMake(30, 30);
    self.closeButtonNode.style.layoutPosition = CGPointMake(-15.0f, -12.0f);
    
    self.adsTextNode.style.width = ASDimensionMake(30.0f);
    self.adsTextNode.style.height = ASDimensionMake(30.0f);
    self.adsTextNode.style.layoutPosition = CGPointMake(45.0f, 0.0f);
    
    ASAbsoluteLayoutSpec *absoluteLayoutSpec = [ASAbsoluteLayoutSpec absoluteLayoutSpecWithSizing:ASAbsoluteLayoutSpecSizingSizeToFit children:@[_botCammentNode, _closeButtonNode, _adsTextNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, -40.0f) child:absoluteLayoutSpec];
}

- (void)didTapOnCloseButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(botCammentCellDidTapOnCloseButton:)]) {
        [self.delegate botCammentCellDidTapOnCloseButton:self];
    }
}

@end
