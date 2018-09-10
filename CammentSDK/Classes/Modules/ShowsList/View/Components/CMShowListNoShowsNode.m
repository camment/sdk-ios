//
// Created by Alexander Fedosov on 10.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMShowListNoShowsNode.h"
#import "UIColorMacros.h"


@interface CMShowListNoShowsNode ()
@property(nonatomic, strong) ASTextNode *textNode;
@property(nonatomic, strong) ASTextNode *welcomeTextNode;
@property(nonatomic, strong) ASDisplayNode *cardNode;
@end

@implementation CMShowListNoShowsNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.welcomeTextNode = [ASTextNode new];
        self.welcomeTextNode.attributedText = [[NSAttributedString alloc] initWithString:@"Welcome!"
                                                                       attributes:@{
                                                                               NSFontAttributeName: [UIFont boldSystemFontOfSize:36.0f],
                                                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                       }];

        self.textNode = [ASTextNode new];
        self.textNode.attributedText = [[NSAttributedString alloc] initWithString:@"To get started open an invitation link from your friend or copy it to clipboard"
                                                                       attributes:@{
                                                                               NSFontAttributeName: [UIFont systemFontOfSize:18.0f],
                                                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                       }];
        self.cardNode = [ASDisplayNode new];
        self.cardNode.cornerRadius = 15.0f;
        self.cardNode.backgroundColor = UIColorFromRGB(0x2b7cec);
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];

    self.clipsToBounds = NO;

    self.cardNode.cornerRadius = 15.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 15.0f;
    self.layer.shadowOpacity = .5f;
    self.layer.shadowOffset = CGSizeMake(.0f, .0f);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.layer.bounds cornerRadius:15.0f].CGPath;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:20.0f
                                                                          justifyContent:ASStackLayoutJustifyContentStart
                                                                              alignItems:ASStackLayoutAlignItemsStart
                                                                                children:@[_welcomeTextNode, _textNode]];

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                  child:[ASOverlayLayoutSpec overlayLayoutSpecWithChild:_cardNode
                                                                                                overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(INFINITY, 30.0f, 30.0f, 30.0f)
                                                                                                                                                child:stackLayoutSpec]]];
}

@end