//
// Created by Alexander Fedosov on 12.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMProfileViewNode.h"
#import "UIColorMacros.h"
#import "CMStore.h"


@interface CMProfileViewNode ()
@property(nonatomic, strong) ASTextNode *usernameTextNode;
@property(nonatomic, strong) ASNetworkImageNode *userpicImageNode;
@property(nonatomic, strong) ASButtonNode *settingsButtonNode;
@end

@implementation CMProfileViewNode {

}

- (instancetype)init {
    self = [super init];
    if (self) {

        self.backgroundColor = UIColorFromRGB(0xE6E6E6);

        self.usernameTextNode = [ASTextNode new];
        self.userpicImageNode = [ASNetworkImageNode new];
        self.userpicImageNode.clipsToBounds = YES;
        self.userpicImageNode.contentMode = UIViewContentModeScaleAspectFill;

        self.settingsButtonNode = [ASButtonNode new];
        self.settingsButtonNode.style.height = ASDimensionMake(30.0f);
        [self.settingsButtonNode setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"Learn more")
                                                                                     attributes:@{
                                                                                             NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:10],
                                                                                             NSForegroundColorAttributeName: UIColorFromRGB(0x4A90E2),
                                                                                     }]
                                            forState:UIControlStateNormal];
        [self.settingsButtonNode addTarget:self
                                     action:@selector(tapLearnMoreButton)
                           forControlEvents:ASControlNodeEventTouchUpInside];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
    
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
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    self.userpicImageNode.style.width = ASDimensionMake(58.0f);
    self.userpicImageNode.style.height = ASDimensionMake(58.0f);
    self.userpicImageNode.cornerRadius = 29.0f;

    ASStackLayoutSpec *centerStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                             spacing:8.0f
                                                                      justifyContent:ASStackLayoutJustifyContentCenter
                                                                          alignItems:ASStackLayoutAlignItemsStretch
                                                                            children:@[[ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringX sizingOptions:ASCenterLayoutSpecSizingOptionDefault child:_userpicImageNode], _usernameTextNode]];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(28.0f, 32.0f, 32.0f, 28.0f)
                                                  child:centerStack];
}

@end
