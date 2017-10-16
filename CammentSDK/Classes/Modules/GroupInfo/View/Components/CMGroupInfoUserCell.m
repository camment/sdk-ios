//
// Created by Alexander Fedosov on 13.10.2017.
//

#import "CMGroupInfoUserCell.h"
#import "CMUser.h"
#import "UIColorMacros.h"


@interface CMGroupInfoUserCell ()
@property(nonatomic, strong) ASTextNode *usernameNode;

@property(nonatomic, strong) ASDisplayNode *bottomSeparatorNode;
@property(nonatomic, strong) CMUser *user;
@property(nonatomic, strong) ASNetworkImageNode *userpicImageNode;
@end

@implementation CMGroupInfoUserCell {

}


- (instancetype)initWithUser:(CMUser *) user {
    self = [super init];
    if (self) {
        self.user = user;
        
        self.backgroundColor = [UIColor whiteColor];

        self.userpicImageNode = [ASNetworkImageNode new];
        self.userpicImageNode.clipsToBounds = YES;
        self.userpicImageNode.contentMode = UIViewContentModeScaleAspectFill;
        
        self.usernameNode = [ASTextNode new];
        self.usernameNode.attributedText = [[NSAttributedString alloc] initWithString:user.username
                                                                             attributes:@{
                                                                                     NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]
                                                                             }];

        self.bottomSeparatorNode = [ASDisplayNode new];
        self.bottomSeparatorNode.backgroundColor = [UIColorFromRGB(0x4A4A4A) colorWithAlphaComponent:0.3];
        self.bottomSeparatorNode.style.height = ASDimensionMake(1.0f);

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];

    if (self.user.userPhoto) {
        NSURL *userpicURL = [[NSURL alloc] initWithString:self.user.userPhoto];
        if (userpicURL) {
            [self.userpicImageNode setURL:userpicURL resetToDefault:NO];
        }
    }
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    _userpicImageNode.style.width = ASDimensionMake(36.0f);
    _userpicImageNode.style.height = ASDimensionMake(36.0f);
    _userpicImageNode.cornerRadius = 18.0f;
    _userpicImageNode.clipsToBounds = YES;

    _usernameNode.style.minHeight = ASDimensionMake(20.0f);
    ASInsetLayoutSpec * insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f)
                                                                           child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                                                         spacing:5.0f
                                                                                                                  justifyContent:ASStackLayoutJustifyContentStart
                                                                                                                      alignItems:ASStackLayoutAlignItemsCenter
                                                                                                                        children:@[_userpicImageNode, _usernameNode]]];
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[insetSpec, _bottomSeparatorNode]];
}

@end