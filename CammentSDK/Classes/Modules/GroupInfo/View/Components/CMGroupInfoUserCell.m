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
@property(nonatomic, readonly) BOOL showDeleteUserButton;
@property(nonatomic, strong) ASButtonNode *deleteUserButtonNode;
@end

@implementation CMGroupInfoUserCell {

}


- (instancetype)initWithUser:(CMUser *)user showDeleteUserButton:(BOOL)showDeleteUserButton {
    self = [super init];
    if (self) {
        self.user = user;
        _showDeleteUserButton = showDeleteUserButton;
        
        self.backgroundColor = [UIColor whiteColor];

        self.userpicImageNode = [ASNetworkImageNode new];
        self.userpicImageNode.clipsToBounds = YES;
        self.userpicImageNode.contentMode = UIViewContentModeScaleAspectFill;
        
        self.usernameNode = [ASTextNode new];
        self.usernameNode.maximumNumberOfLines = 1;
        self.usernameNode.truncationMode = NSLineBreakByTruncatingTail;
        self.usernameNode.attributedText = [[NSAttributedString alloc] initWithString:user.username
                                                                             attributes:@{
                                                                                     NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]
                                                                             }];

        self.bottomSeparatorNode = [ASDisplayNode new];
        self.bottomSeparatorNode.backgroundColor = [UIColorFromRGB(0x4A4A4A) colorWithAlphaComponent:0.3];
        self.bottomSeparatorNode.style.height = ASDimensionMake(1.0f);

        if (self.showDeleteUserButton) {
            self.deleteUserButtonNode = [ASButtonNode new];
            [self.deleteUserButtonNode setImage:[UIImage imageNamed:@"delete_icon"
                                                           inBundle:[NSBundle cammentSDKBundle]
                                      compatibleWithTraitCollection:nil]
                                       forState:UIControlStateNormal];
            [self.deleteUserButtonNode addTarget:self
                                          action:@selector(didTapDeleteButton)
                                forControlEvents:ASControlNodeEventTouchUpInside];
        }
        
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didTapDeleteButton {
    [self.delegate useCell:self didHandleDeleteUserAction:self.user];
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

    _usernameNode.style.flexGrow = 1.0f;
    _usernameNode.style.flexShrink = 1.0f;
    _usernameNode.style.minHeight = ASDimensionMake(20.0f);

    NSMutableArray *stackLayoutChildren = [NSMutableArray arrayWithArray:@[_userpicImageNode, _usernameNode]];

    if (self.showDeleteUserButton) {
        _deleteUserButtonNode.style.preferredSize = CGSizeMake(44.0f, 44.0f);
        ASRatioLayoutSpec *spec = [ASRatioLayoutSpec ratioLayoutSpecWithRatio:1
                                                                        child:_deleteUserButtonNode];
        [stackLayoutChildren addObject:spec];
    }
    
    ASInsetLayoutSpec * insetSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:
                                     UIEdgeInsetsMake(
                                                      self.showDeleteUserButton ? .0f : 5.0f,
                                                      10.0f,
                                                      self.showDeleteUserButton ? .0f : 5.0f,
                                                      self.showDeleteUserButton ? 2.0f : 10.0f)
                                                                           child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                                                         spacing:5.0f
                                                                                                                  justifyContent:ASStackLayoutJustifyContentStart
                                                                                                                      alignItems:ASStackLayoutAlignItemsCenter
                                                                                                                        children:stackLayoutChildren]];
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[insetSpec, _bottomSeparatorNode]];
}

@end
