//
// Created by Alexander Fedosov on 10.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMShowListNoShowsNode.h"
#import "UIColorMacros.h"


@interface CMShowListNoShowsNode ()
@property(nonatomic, strong) ASTextNode *textNode;
@property(nonatomic, strong) ASDisplayNode *cardNode;
@end

@implementation CMShowListNoShowsNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.textNode = [ASTextNode new];
        self.textNode.attributedText = [[NSAttributedString alloc] initWithString:@"Open invitation link or copy it to clipboard"
                                                                       attributes:@{
                                                                               NSFontAttributeName: [UIFont systemFontOfSize:36.0f],
                                                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                       }];
        self.cardNode = [ASDisplayNode new];
        self.cardNode.cornerRadius = 15.0f;
        self.cardNode.backgroundColor = UIColorFromRGB(0x287CEC);
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f)
                                                  child:[ASOverlayLayoutSpec overlayLayoutSpecWithChild:_cardNode
                                                                                                overlay:[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                                                                                                                   sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY
                                                                                                                                                           child:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(30.0f, 30.0f, 30.0f, 30.0f)
                                                                                                                                                                                                        child:_textNode]]]];
}

@end