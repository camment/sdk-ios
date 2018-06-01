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
#import "UIFont+CammentFonts.h"

@interface CMProfileViewNode ()

@property(nonatomic, strong) ASTextNode *usernameTextNode;
@property(nonatomic, strong) ASNetworkImageNode *userpicImageNode;
@property(nonatomic, strong) ASButtonNode *logoutButtonNode;
@property(nonatomic, strong) ASDisplayNode *bottomSeparatorNode;
@property(nonatomic, strong) CMProfileViewNodeContext *context;
@property(nonatomic, strong) NSString *userId;

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

        self.logoutButtonNode = [ASButtonNode new];
        self.logoutButtonNode.style.height = ASDimensionMake(38.0f);
        self.logoutButtonNode.style.width = ASDimensionMake(38.0f);
        [self.logoutButtonNode setContentEdgeInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];

        [self.logoutButtonNode addTarget:self
                                    action:@selector(tapLogoutButton)
                          forControlEvents:ASControlNodeEventTouchUpInside];

        self.bottomSeparatorNode = [ASDisplayNode new];
        self.bottomSeparatorNode.backgroundColor = [UIColorFromRGB(0x4A4A4A) colorWithAlphaComponent:0.3];
        self.bottomSeparatorNode.style.height = ASDimensionMake(1.0f);

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)tapLogoutButton {
    if (self.context.onLogout) {
        self.context.onLogout();
    }
}

- (void)didLoad {
    [super didLoad];
    
    [self.logoutButtonNode setImage:[UIImage imageNamed:@"logout_button"
                                                 inBundle:[NSBundle cammentSDKBundle]
                            compatibleWithTraitCollection:nil]
                             forState:UIControlStateNormal];

    NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
    mutableParagraphStyle.alignment = NSTextAlignmentCenter;

    @weakify(self);
    [[[RACObserve([CMUserSessionController instance], user) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
            subscribeNext:^(CMUser *user) {
                @strongify(self);

                self.userId = user.cognitoUserId;
                self.usernameTextNode.attributedText = [[NSAttributedString alloc] initWithString:user.username ?: @""
                                                                                       attributes:@{
                                                                                               NSFontAttributeName: [UIFont nunitoMediumWithSize:14],
                                                                                               NSForegroundColorAttributeName: [UIColor blackColor],
                                                                                               NSParagraphStyleAttributeName: mutableParagraphStyle
                                                                                       }];

                if (user.userPhoto) {
                    NSURL *userpicURL = [[NSURL alloc] initWithString:user.userPhoto];
                    if (userpicURL) {
                        [self.userpicImageNode setURL:userpicURL resetToDefault:NO];
                    }
                }

                [self setNeedsLayout];
            }];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.userpicImageNode.style.width = ASDimensionMake(58.0f);
    self.userpicImageNode.style.height = ASDimensionMake(58.0f);
    self.userpicImageNode.cornerRadius = 29.0f;

    ASInsetLayoutSpec *userPicWithInsetsSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, 22.0f, .0f, 22.0f)
                                                                                      child:_userpicImageNode];

    NSMutableArray *centerStackChildren = [NSMutableArray new];
    [centerStackChildren addObjectsFromArray:@[
            [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX
                                                       sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                               child:userPicWithInsetsSpec],
            [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                    spacing:4.0f
                                             justifyContent:ASStackLayoutJustifyContentCenter
                                                 alignItems:ASStackLayoutAlignItemsCenter
                                                   children:@[_usernameTextNode]]]
    ];

    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:8.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                                            children:centerStackChildren];
    ASInsetLayoutSpec *componentsStack = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(28.0f, 32.0f, 15.0f, 32.0f)
                                                                                child:centerStack];

    ASOverlayLayoutSpec *overlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:componentsStack
                                                                                 overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, INFINITY, INFINITY, .0f) child:_logoutButtonNode]];
    NSArray *childen = @[overlayLayout, _bottomSeparatorNode];

    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:childen];
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
        [context completeTransition:finished];
    }];
}


@end
