//
// Created by Alexander Fedosov on 20.09.17.
//

#import "ASCollectionNode.h"
#import "CMGroupCellNode.h"
#import "CMUsersGroup.h"
#import "UIFont+CammentFonts.h"
#import "NSArray+RacSequence.h"
#import "CMGroupAvatarNode.h"
#import "UIColorMacros.h"

@interface CMGroupCellNode ()

@property(nonatomic, strong) ASTextNode *groupNameNode;
@property(nonatomic, strong) CMGroupAvatarNode *avatarNode;
@property(nonatomic, strong) ASDisplayNode *backgroundNode;

@end

@implementation CMGroupCellNode {

}

- (instancetype)initWithGroup:(CMUsersGroup *)group{
    self = [super init];
    if (self) {
        _group = group;

        self.groupNameNode = [ASTextNode new];
        self.groupNameNode.maximumNumberOfLines = 1;
        self.groupNameNode.truncationMode = NSLineBreakByTruncatingTail;
        self.groupNameNode.style.flexShrink = 1;
        self.groupNameNode.attributedText = [[NSAttributedString alloc] initWithString:[[group.users map:^id(CMUser *user) {
            return user.username;
        }] componentsJoinedByString:@", "] attributes:@{
                NSFontAttributeName: [UIFont nunitoMediumWithSize:14],
        }];


        self.avatarNode = [[CMGroupAvatarNode alloc] initWithImageUrls:[group.users map:^id(CMUser *user) {
            return user.userPhoto;
        }]];

        self.avatarNode.clipsToBounds = YES;
        self.avatarNode.borderColor = [UIColor whiteColor].CGColor;
        self.avatarNode.borderWidth = 1.0f;
        self.avatarNode.style.width = ASDimensionMake(36.0f);
        self.avatarNode.style.height = ASDimensionMake(36.0f);
        self.avatarNode.cornerRadius = 18.0f;

        self.backgroundNode = [ASDisplayNode new];
        self.backgroundNode.backgroundColor = UIColorFromRGB(0xE6E6E6);
        self.backgroundNode.style.height = ASDimensionMake(44.0f);
        self.clipsToBounds = YES;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    self.avatarNode.layer.masksToBounds = YES;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *insetsContentLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(4, 4, 4, 4)
                                child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:10.0f
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[_avatarNode, _groupNameNode]]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(1, 8, 1, 8)
                                                  child:[ASOverlayLayoutSpec
                                                          overlayLayoutSpecWithChild:_backgroundNode
                                                          overlay:insetsContentLayout]];
}

@end
