//
// Created by Alexander Fedosov on 12.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMProfileViewNode.h"
#import "ReactiveObjC.h"
#import "UIColorMacros.h"
#import "CMUserSessionController.h"
#import "CMSettingsNode.h"
#import "CammentSDK.h"
#import "CMProfileViewNodeContext.h"
#import "CMStore.h"
#import "CMOpenURLHelper.h"
#import "CMInviteFriendsButton.h"
#import "CMProfileViewNodeContext.h"
#import "CMInviteFriendsGroupInfoNode.h"

@interface CMProfileViewNode () <CMSettingsNodeDelegate>

@property(nonatomic, strong) ASTextNode *usernameTextNode;
@property(nonatomic, strong) ASNetworkImageNode *userpicImageNode;
@property(nonatomic, strong) ASImageNode *fbImageNode;
@property(nonatomic, strong) ASButtonNode *settingsButtonNode;
@property(nonatomic, strong) ASDisplayNode *bottomSeparatorNode;
@property(nonatomic, strong) CMSettingsNode *settingsNode;
@property(nonatomic, strong) CMInviteFriendsButton *inviteFriendsButtonNode;

@property BOOL showSettingsNode;

@property(nonatomic, strong) CMProfileViewNodeContext *context;
@end

@implementation CMProfileViewNode {

}

- (instancetype)init {
    CMProfileViewNodeContext *context = [CMProfileViewNodeContext new];
    return [self initWithContext:context];
}

- (instancetype)initWithContext:(CMProfileViewNodeContext *)context {
    self = [super init];

    if (self) {
        self.context = context;
        self.backgroundColor = UIColorFromRGB(0xE6E6E6);

        self.usernameTextNode = [ASTextNode new];

        self.userpicImageNode = [ASNetworkImageNode new];
        self.userpicImageNode.clipsToBounds = YES;
        self.userpicImageNode.contentMode = UIViewContentModeScaleAspectFill;

        self.settingsButtonNode = [ASButtonNode new];
        self.settingsButtonNode.style.height = ASDimensionMake(38.0f);
        self.settingsButtonNode.style.width = ASDimensionMake(38.0f);
        [self.settingsButtonNode setContentEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];

        [self.settingsButtonNode addTarget:self
                                    action:@selector(tapSettingButton)
                          forControlEvents:ASControlNodeEventTouchUpInside];

        self.bottomSeparatorNode = [ASDisplayNode new];
        self.bottomSeparatorNode.backgroundColor = [UIColorFromRGB(0x4A4A4A) colorWithAlphaComponent:0.3];
        self.bottomSeparatorNode.style.height = ASDimensionMake(1.0f);

        self.fbImageNode = [ASImageNode new];
        self.fbImageNode.style.height = ASDimensionMake(18.0f);
        self.fbImageNode.style.width = ASDimensionMake(18.0f);

        self.settingsNode = [CMSettingsNode new];
        self.settingsNode.delegate = self;

        self.inviteFriendsButtonNode = [CMInviteFriendsButton new];
        [self.inviteFriendsButtonNode addTarget:self
                                         action:@selector(inviteFriendsAction)
                               forControlEvents:ASControlNodeEventTouchUpInside];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)tapSettingButton {
    [self switchSettingsView];
}

- (void)inviteFriendsAction {
    [self.context.delegate handleDidTapInviteFriendsButton];
}

- (void)didLoad {
    [super didLoad];

    [self.settingsButtonNode setImage:[UIImage imageNamed:@"settings_icn"
                                                 inBundle:[NSBundle cammentSDKBundle]
                            compatibleWithTraitCollection:nil]
                             forState:UIControlStateNormal];

    [self.fbImageNode setImage:[UIImage imageNamed:@"fb_logo"
                                          inBundle:[NSBundle cammentSDKBundle]
                     compatibleWithTraitCollection:nil]];

    self.userpicImageNode.userInteractionEnabled = YES;
    UIGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openUserProfile)];
    [self.userpicImageNode.view addGestureRecognizer:gestureRecognizer];

    NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
    mutableParagraphStyle.alignment = NSTextAlignmentCenter;

    @weakify(self);
    [[[RACObserve([CMUserSessionController instance], user) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
            subscribeNext:^(CMUser *user) {
                @strongify(self);

                if (!user) {
                    _showSettingsNode = NO;
                }
                self.usernameTextNode.attributedText = [[NSAttributedString alloc] initWithString:user.username ?: @""
                                                                                       attributes:@{
                                                                                               NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                                               NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                               NSParagraphStyleAttributeName: mutableParagraphStyle
                                                                                       }];

                if (user.userPhoto) {
                    NSURL *userpicURL = [[NSURL alloc] initWithString:user.userPhoto];
                    if (userpicURL) {
                        [self.userpicImageNode setURL:userpicURL resetToDefault:NO];
                    }
                }

                [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
            }];
}

- (void)openUserProfile {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://facebook.com/%@", [CMUserSessionController instance].user.fbUserId]];
    [[CMOpenURLHelper new] openURL:url];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.userpicImageNode.style.width = ASDimensionMake(58.0f);
    self.userpicImageNode.style.height = ASDimensionMake(58.0f);
    self.userpicImageNode.cornerRadius = 29.0f;

    ASInsetLayoutSpec *userPicWithInsetsSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 22.0f, .0f, 22.0f)
                                                                                      child:_userpicImageNode];
    ASOverlayLayoutSpec *fbLogoOverlay = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:userPicWithInsetsSpec
                                                                                 overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, INFINITY, INFINITY, .0f)
                                                                                                                                child:[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringY
                                                                                                                                                                                 sizingOptions:ASCenterLayoutSpecSizingOptionMinimumX
                                                                                                                                                                                         child:_fbImageNode]]];

    NSMutableArray *centerStackChildren = [NSMutableArray new];
    [centerStackChildren addObjectsFromArray:@[
            [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX
                                                       sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                               child:fbLogoOverlay],
            _usernameTextNode]
    ];

    if (self.context.shouldDisplayInviteFriendsButton) {
        ASInsetLayoutSpec *inviteFriendsButtonLayoutSpec = [ASInsetLayoutSpec
                insetLayoutSpecWithInsets:UIEdgeInsetsMake(10.0f, .0f, .0f, .0f)
                                    child:self.inviteFriendsButtonNode];
        [centerStackChildren addObject:inviteFriendsButtonLayoutSpec];
    }

    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:8.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                                            children:centerStackChildren];
    ASInsetLayoutSpec *componentsStack = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(28.0f, 32.0f, 28.0f, 32.0f)
                                                                                child:centerStack];

    ASOverlayLayoutSpec *overlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:componentsStack
                                                                                 overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, INFINITY, INFINITY, .0f) child:_settingsButtonNode]];
    NSArray *childen = @[ _showSettingsNode ? _settingsNode : overlayLayout, _bottomSeparatorNode];

    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:childen];
}

- (void)settingsNodeDidCloseSettingsView:(CMSettingsNode *)node {
    [self switchSettingsView];
}

- (void)switchSettingsView {
    self.showSettingsNode = !self.showSettingsNode;
    [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
}

- (void)settingsNodeDidLogout:(CMSettingsNode *)node {
    [[CammentSDK instance] logOut];
}

- (void)animateLayoutTransition:(id<ASContextTransitioning>)context {
    if (![context isAnimated]) {
        [super animateLayoutTransition:context];
        return;
    }

    [UIView animateWithDuration:self.defaultLayoutTransitionDuration animations:^{

        for (ASDisplayNode *node in context.removedSubnodes) {
            node.alpha = .0f;
        }

        for (ASDisplayNode *node in context.insertedSubnodes) {
            node.alpha = 1.0f;
        }

    } completion:^(BOOL finished) {
        [context completeTransition:YES];
    }];
}

@end
