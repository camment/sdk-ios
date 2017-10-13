//
// Created by Alexander Fedosov on 12.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMProfileViewNode.h"
#import "UIColorMacros.h"
#import "CMStore.h"


@interface CMProfileViewNode ()
@property(nonatomic, strong) ASTextNode *usernameTextNode;
@property(nonatomic, strong) ASTextNode *userinfoTextNode;
@property(nonatomic, strong) ASNetworkImageNode *userpicImageNode;
@property(nonatomic, strong) ASImageNode *fbImageNode;
@property(nonatomic, strong) ASButtonNode *settingsButtonNode;
@property(nonatomic, strong) ASDisplayNode *bottomSeparatorNode;
@end

@implementation CMProfileViewNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.backgroundColor = UIColorFromRGB(0xE6E6E6);

        self.usernameTextNode = [ASTextNode new];
        self.userinfoTextNode = [ASTextNode new];

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

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)tapSettingButton {

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

    NSMutableParagraphStyle *mutableParagraphStyle = [NSMutableParagraphStyle new];
    mutableParagraphStyle.alignment = NSTextAlignmentCenter;

    @weakify(self);
    [[[RACObserve([CMStore instance], currentUser) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
            subscribeNext:^(CMUser *user) {
                @strongify(self);

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

    [[[RACObserve([CMStore instance], userGroups) takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
            subscribeNext:^(NSArray *groups) {
                @strongify(self);

                NSString *groupsCountString;

                if (groups.count == 0) {
                    groupsCountString = [NSString stringWithFormat:@"No group found"];
                } else if (groups.count == 1) {
                    groupsCountString = [NSString stringWithFormat:@"1 group joined"];
                } else {
                    groupsCountString = [NSString stringWithFormat:@"%d groups joined", groups.count];
                }

                self.userinfoTextNode.attributedText = [[NSAttributedString alloc] initWithString:groupsCountString
                                                                                       attributes:@{
                                                                                               NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                                               NSForegroundColorAttributeName: UIColorFromRGB(0x9B9B9B),
                                                                                               NSParagraphStyleAttributeName: mutableParagraphStyle
                                                                                       }];

                [self transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
            }];
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

    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:8.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                                            children:@[[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX
                                                                                                                                  sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                                                                                                                          child:fbLogoOverlay],
                                                                                    _usernameTextNode,
                                                                                    _userinfoTextNode]];
    ASInsetLayoutSpec *componentsStack = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(28.0f, 32.0f, 32.0f, 28.0f)
                                                                                child:centerStack];

    ASOverlayLayoutSpec *overlayLayout = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:componentsStack
                                                                                 overlay:[ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, INFINITY, INFINITY, .0f) child:_settingsButtonNode]];
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                   spacing:.0f
                                            justifyContent:ASStackLayoutJustifyContentStart
                                                alignItems:ASStackLayoutAlignItemsStretch
                                                  children:@[overlayLayout, _bottomSeparatorNode]];
}

@end
