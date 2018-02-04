//
// Created by Alexander Fedosov on 23.01.2018.
//

#import "CMInviteFriendsButton.h"
#import "UIColorMacros.h"


@implementation CMInviteFriendsButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.style.minHeight = ASDimensionMake(30.0f);
        self.contentEdgeInsets = UIEdgeInsetsMake(.0f, 10.0f, .0f, 10.0f);
        self.backgroundColor = UIColorFromRGB(0xD0021B);
        [self setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"button.invite_friends")
                                                                 attributes:@{
                                                                         NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                 }]
                        forState:UIControlStateNormal];
    }

    return self;
}

@end

@implementation CMContinueTutorialButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.style.minHeight = ASDimensionMake(30.0f);
        self.contentEdgeInsets = UIEdgeInsetsMake(.0f, 10.0f, .0f, 10.0f);
        self.backgroundColor = UIColorFromRGB(0x9B9B9B);
        [self setAttributedTitle:[[NSAttributedString alloc] initWithString:CMLocalized(@"button.continue_tutorial")
                                                                 attributes:@{
                                                                         NSFontAttributeName: [UIFont fontWithName:@"Nunito-Medium" size:14],
                                                                         NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                 }]
                        forState:UIControlStateNormal];
    }

    return self;
}

@end