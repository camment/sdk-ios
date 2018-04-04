//
// Created by Alexander Fedosov on 13.10.2017.
//

#import "CMPeopleJoinedHeaderCell.h"
#import "UIColorMacros.h"
#import "UIFont+CammentFonts.h"


@interface CMPeopleJoinedHeaderCell ()
@property(nonatomic, strong) ASTextNode *textHeaderNode;
@property(nonatomic, strong) ASDisplayNode *bottomSeparatorNode;
@end

@implementation CMPeopleJoinedHeaderCell {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        self.textHeaderNode = [ASTextNode new];
        self.textHeaderNode.attributedText = [[NSAttributedString alloc] initWithString:CMLocalized(@"People joined to your Camment chat")
                                                                             attributes:@{
                                                                                     NSFontAttributeName: [UIFont nunitoMediumWithSize:12],
                                                                                     NSForegroundColorAttributeName: UIColorFromRGB(0x9B9B9B)
                                                                             }];

        self.bottomSeparatorNode = [ASDisplayNode new];
        self.bottomSeparatorNode.backgroundColor = [UIColorFromRGB(0x4A4A4A) colorWithAlphaComponent:0.3];
        self.bottomSeparatorNode.style.height = ASDimensionMake(1.0f);

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    _textHeaderNode.style.minHeight = ASDimensionMake(20.0f);
    ASInsetLayoutSpec * insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8.0f, 10.0f, 4.0f, 10.0f) child:_textHeaderNode];
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[insetSpec, _bottomSeparatorNode]];
}

@end
