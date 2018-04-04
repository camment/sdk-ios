//
// Created by Alexander Fedosov on 12.10.2017.
//

#import "CMInviteFriendsGroupInfoNode.h"
#import "UIColorMacros.h"
#import "CMInviteFriendsButton.h"
#import "UIFont+CammentFonts.h"


@interface CMInviteFriendsGroupInfoNode ()

@property(nonatomic, strong) ASTextNode *infoTextNode;
@property(nonatomic, strong) ASButtonNode *learnMoreButtonNode;
@property(nonatomic, strong) CMInviteFriendsButton *inviteFriendsButtonNode;
@property(nonatomic, strong) CMContinueTutorialButton *continueTutorialButton;

@end

@implementation CMInviteFriendsGroupInfoNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.infoTextNode = [ASTextNode new];
        NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
        mutableParagraphStyle.alignment = NSTextAlignmentCenter;

        self.infoTextNode.attributedText = [[NSAttributedString alloc] initWithString:CMLocalized(@"Invite friends to chat with short videos in top of your stream.")
                                                                           attributes:@{
                                                                                   NSFontAttributeName: [UIFont nunitoMediumWithSize:12],
                                                                                   NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                   NSParagraphStyleAttributeName: mutableParagraphStyle
                                                                           }];

        self.learnMoreButtonNode = [ASButtonNode new];
        self.learnMoreButtonNode.style.height = ASDimensionMake(30.0f);
        [self.learnMoreButtonNode setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"Learn more")
                                                                                     attributes:@{
                                                                                             NSFontAttributeName: [UIFont nunitoMediumWithSize:10],
                                                                                             NSForegroundColorAttributeName: UIColorFromRGB(0x4A90E2),
                                                                                     }]
                                            forState:UIControlStateNormal];
        [self.learnMoreButtonNode addTarget:self
                                     action:@selector(tapLearnMoreButton)
                           forControlEvents:ASControlNodeEventTouchUpInside];

        self.inviteFriendsButtonNode = [CMInviteFriendsButton new];
        [self.inviteFriendsButtonNode addTarget:self
                                     action:@selector(tapInviteFriendsButton)
                           forControlEvents:ASControlNodeEventTouchUpInside];

        self.continueTutorialButton = [CMContinueTutorialButton new];
        [self.continueTutorialButton addTarget:self
                                         action:@selector(tapContinueTutorialButton)
                               forControlEvents:ASControlNodeEventTouchUpInside];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)tapContinueTutorialButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleDidTapContinueTutorialButton)]) {
        [self.delegate handleDidTapContinueTutorialButton];
    }
}

- (void)tapInviteFriendsButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleDidTapInviteFriendsButton)]) {
        [self.delegate handleDidTapInviteFriendsButton];
    }
}

- (void)tapLearnMoreButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteFriendsGroupInfoNodeDidTapLearnMoreButton:)]) {
        [self.delegate inviteFriendsGroupInfoNodeDidTapLearnMoreButton:self];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASInsetLayoutSpec *infoTextLayoutSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 32.0f, .0f, 32.0f)
                                child:_infoTextNode];

    ASInsetLayoutSpec *inviteFriendsButtonLayoutSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(10.0f, 32.0f, .0f, 32.0f)
                                child:_inviteFriendsButtonNode];

    ASInsetLayoutSpec *continueTutorialLayoutSpec = [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(10.0f, 32.0f, .0f, 32.0f)
                                child:_continueTutorialButton];
    
    NSMutableArray *children = [NSMutableArray new];
    [children addObjectsFromArray:@[
            infoTextLayoutSpec,
            _learnMoreButtonNode, 
            inviteFriendsButtonLayoutSpec
    ]];
    
    if (self.showContinueTutorialButton) {
        [children addObject:continueTutorialLayoutSpec];
    }
    
    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                                            children:children];
    return centerStack;
}


@end
