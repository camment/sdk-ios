//
// Created by Alexander Fedosov on 12.10.2017.
//

#import "CMNotSignedInGroupInfoNode.h"
#import "UIColorMacros.h"


@interface CMNotSignedInGroupInfoNode ()

@property(nonatomic, strong) ASTextNode *infoTextNode;
@property(nonatomic, strong) ASButtonNode *learnMoreButtonNode;
@property(nonatomic, strong) ASButtonNode *inviteFriendsButtonNode;

@end

@implementation CMNotSignedInGroupInfoNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.infoTextNode = [ASTextNode new];
        NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
        mutableParagraphStyle.alignment = NSTextAlignmentCenter;

        self.infoTextNode.attributedText = [[NSAttributedString alloc] initWithString:CMLocalized(@"Invite friends to chat with short videos in top of your stream.")
                                                                           attributes:@{
                                                                                   NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:12],
                                                                                   NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                   NSParagraphStyleAttributeName: mutableParagraphStyle
                                                                           }];

        self.learnMoreButtonNode = [ASButtonNode new];
        self.learnMoreButtonNode.style.height = ASDimensionMake(30.0f);
        [self.learnMoreButtonNode setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"Learn more")
                                                                                     attributes:@{
                                                                                             NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:10],
                                                                                             NSForegroundColorAttributeName: UIColorFromRGB(0x4A90E2),
                                                                                     }]
                                            forState:UIControlStateNormal];
        [self.learnMoreButtonNode addTarget:self
                                     action:@selector(tapLearnMoreButton)
                           forControlEvents:ASControlNodeEventTouchUpInside];

        self.inviteFriendsButtonNode = [ASButtonNode new];
        self.inviteFriendsButtonNode.backgroundColor = UIColorFromRGB(0xD0021B);
        self.inviteFriendsButtonNode.style.width = ASDimensionMake(120.0f);
        self.inviteFriendsButtonNode.style.height = ASDimensionMake(30.0f);
        [self.inviteFriendsButtonNode setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"Invite friends")
                                                                                     attributes:@{
                                                                                             NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                                             NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                     }]
                                            forState:UIControlStateNormal];
        [self.inviteFriendsButtonNode addTarget:self
                                     action:@selector(tapInviteFriendsButton)
                           forControlEvents:ASControlNodeEventTouchUpInside];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)tapInviteFriendsButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(notSignedNodeDidTapInviteFriendsButton:)]) {
        [self.delegate notSignedNodeDidTapInviteFriendsButton:self];
    }
}

- (void)tapLearnMoreButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(notSignedNodeDidTapLearnMoreButton:)]) {
        [self.delegate notSignedNodeDidTapLearnMoreButton:self];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASInsetLayoutSpec *infoTextLayoutSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 32.0f, .0f, 32.0f)
                                child:_infoTextNode];

    ASInsetLayoutSpec *inviteFriendsButtonLayoutSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(10.0f, .0f, .0f, .0f)
                                child:_inviteFriendsButtonNode];

    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsCenter
                                                                            children:@[infoTextLayoutSpec, _learnMoreButtonNode, inviteFriendsButtonLayoutSpec]];
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                      sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY
                                                              child:centerStack];
}


@end
