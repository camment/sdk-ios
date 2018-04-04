//
// Created by Alexander Fedosov on 17.10.2017.
//

#import "CMSettingsNode.h"
#import "UIColorMacros.h"
#import "CMInviteFriendsButton.h"
#import "UIFont+CammentFonts.h"


@interface CMSettingsNode ()

@property(nonatomic, strong) ASTextNode *infoTextNode;
@property(nonatomic, strong) ASButtonNode *logoutButton;
@property(nonatomic, strong) CMLeaveGroupButton *leaveGroupButton;
@property(nonatomic, strong) ASButtonNode *closeButton;

@end

@implementation CMSettingsNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logoutButton = [ASButtonNode new];
        self.logoutButton.style.height = ASDimensionMake(30.0f);
        [self.logoutButton setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"Logout")
                                                                              attributes:@{
                                                                                      NSFontAttributeName: [UIFont nunitoMediumWithSize:10],
                                                                                      NSForegroundColorAttributeName: UIColorFromRGB(0x4A90E2),
                                                                              }]
                                     forState:UIControlStateNormal];
        [self.logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:ASControlNodeEventTouchUpInside];

        self.closeButton = [ASButtonNode new];
        self.closeButton.style.height = ASDimensionMake(38.0f);
        self.closeButton.style.width = ASDimensionMake(38.0f);
        [self.closeButton setContentEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
        [self.closeButton addTarget:self action:@selector(closeSettingsAction) forControlEvents:ASControlNodeEventTouchUpInside];

        self.infoTextNode = [ASTextNode new];
        NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
        mutableParagraphStyle.alignment = NSTextAlignmentCenter;

        self.infoTextNode.attributedText = [[NSAttributedString alloc] initWithString:CMLocalized(@"Logout from Facebook account will remove your from current discussion.")
                                                                           attributes:@{
                                                                                   NSFontAttributeName: [UIFont nunitoMediumWithSize:12],
                                                                                   NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                   NSParagraphStyleAttributeName: mutableParagraphStyle
                                                                           }];
        self.leaveGroupButton = [CMLeaveGroupButton new];
        [self.leaveGroupButton addTarget:self
                                  action:@selector(leaveGroupAction)
                        forControlEvents:ASControlNodeEventTouchUpInside];
        self.automaticallyManagesSubnodes = YES;
    }
    return self;
}

- (void)leaveGroupAction {
    id <CMSettingsNodeDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(settingsNodeDidLeaveTheGroup:)]) {
        [o settingsNodeDidLeaveTheGroup:self];
    }
}

- (void)didLoad {
    [super didLoad];
    [self.closeButton setImage:[UIImage imageNamed:@"profile"
                                          inBundle:[NSBundle cammentSDKBundle]
                     compatibleWithTraitCollection:nil]
                      forState:UIControlStateNormal];
}

- (void)closeSettingsAction {
    id <CMSettingsNodeDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(settingsNodeDidCloseSettingsView:)]) {
        [o settingsNodeDidCloseSettingsView:self];
    }
}

- (void)logoutAction {
    id <CMSettingsNodeDelegate> o = self.delegate;
    if ([o respondsToSelector:@selector(settingsNodeDidLogout:)]) {
        [o settingsNodeDidLogout:self];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    NSMutableArray *children = [NSMutableArray arrayWithArray:@[
            _infoTextNode,
            _logoutButton
    ]];

    if (_shouldDisplayLeaveGroup) {
        [children addObject:_leaveGroupButton];
    }

    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:8.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                                            children:children];

    ASInsetLayoutSpec *componentsStack = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(28.0f, 32.0f, 32.0f, 28.0f)
                                                                                child:centerStack];

    ASOverlayLayoutSpec *overlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:componentsStack
                                                                                 overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, INFINITY, INFINITY, .0f) child:_closeButton]];
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[overlayLayout]];
}

@end
