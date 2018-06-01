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
#import <AWSCore/AWSCategory.h>

@interface CMGroupCellNode ()

@property(nonatomic, strong) ASTextNode *groupNameNode;
@property(nonatomic, strong) ASTextNode *groupCreationDateNode;
@property(nonatomic, strong) CMGroupAvatarNode *avatarNode;
@property(nonatomic, strong) ASDisplayNode *backgroundNode;
@property(nonatomic, strong) ASImageNode *disclosureInidcatorNode;

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
        self.groupNameNode.style.flexGrow= 1;
        self.groupNameNode.attributedText = [[NSAttributedString alloc] initWithString:[[group.users map:^id(CMUser *user) {
            return user.username;
        }] componentsJoinedByString:@", "] attributes:@{
                NSFontAttributeName: [UIFont nunitoMediumWithSize:14],
        }];

        self.groupCreationDateNode = [ASTextNode new];
        self.groupCreationDateNode.maximumNumberOfLines = 1;
        self.groupCreationDateNode.truncationMode = NSLineBreakByTruncatingTail;
        self.groupCreationDateNode.style.flexShrink = 1;
        self.groupCreationDateNode.style.flexGrow= 1;

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"d MMM yyyy";
        
        self.groupCreationDateNode.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:CMLocalized(@"group.created_at"), [formatter stringFromDate:[NSDate aws_dateFromString:group.timestamp]]]
                                                                                    attributes:@{
                                                                                            NSFontAttributeName: [UIFont nunitoLightWithSize:12],
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

        self.disclosureInidcatorNode = [ASImageNode new];
        self.disclosureInidcatorNode.style.width = ASDimensionMake(7.0f);
        self.disclosureInidcatorNode.style.height = ASDimensionMake(12.0f);
        [self.disclosureInidcatorNode onDidLoad:^(__kindof ASImageNode *node) {
            node.image = [UIImage imageNamed:@"disclosure_indicator"
                                             inBundle:[NSBundle cammentSDKBundle]
               compatibleWithTraitCollection:nil];
        }];

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
    ASStackLayoutSpec *textsLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                 spacing:0
                                                                          justifyContent:ASStackLayoutJustifyContentCenter
                                                                              alignItems:ASStackLayoutAlignItemsStretch
                                                                                children:@[_groupNameNode, _groupCreationDateNode]];
    textsLayoutSpec.style.flexGrow = 1;
    textsLayoutSpec.style.flexShrink = 1;

    ASInsetLayoutSpec *insetsContentLayout = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(4, 4, 4, 4)
                                child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                              spacing:10.0f
                                                                       justifyContent:ASStackLayoutJustifyContentStart
                                                                           alignItems:ASStackLayoutAlignItemsCenter
                                                                             children:@[_avatarNode, textsLayoutSpec, _disclosureInidcatorNode]]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(1, 8, 1, 8)
                                                  child:[ASOverlayLayoutSpec
                                                          overlayLayoutSpecWithChild:_backgroundNode
                                                          overlay:insetsContentLayout]];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.backgroundNode.backgroundColor = selected ? UIColorFromRGB(0xBEBEBE) : UIColorFromRGB(0xE6E6E6);
}

@end
