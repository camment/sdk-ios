//
// Created by Alexander Fedosov on 13.10.2017.
//

#import "CMSmallTextHeaderCell.h"
#import "UIColorMacros.h"
#import "UIFont+CammentFonts.h"


@interface CMSmallTextHeaderCell ()
@property(nonatomic, strong) ASTextNode *textHeaderNode;
@end

@implementation CMSmallTextHeaderCell {

}

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];

        self.textHeaderNode = [ASTextNode new];
        self.textHeaderNode.attributedText = [[NSAttributedString alloc] initWithString:text
                                                                             attributes:@{
                                                                                     NSFontAttributeName: [UIFont nunitoMediumWithSize:12],
                                                                                     NSForegroundColorAttributeName: UIColorFromRGB(0x9B9B9B)
                                                                             }];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8.0f, 10.0f, 8.0f, 10.0f) child:_textHeaderNode];
}

@end
