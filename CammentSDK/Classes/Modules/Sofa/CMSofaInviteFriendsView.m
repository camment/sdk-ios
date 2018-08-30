//
// Created by Alexander Fedosov on 20/08/2018.
//

#import "CMSofaInviteFriendsView.h"
#import <CMStore.h>

@implementation CMSofaInviteFriendsView {

}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor lightGrayColor];
        self.alpha = .7f;

        self.inviteFriendsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plus_icon"
                                                                                    inBundle:[NSBundle cammentSDKBundle]
                                                               compatibleWithTraitCollection:nil]];
        self.inviteFriendsImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.inviteFriendsImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.inviteFriendsImageView.layer.shadowOffset = CGSizeMake(.0f, .0f);
        self.inviteFriendsImageView.layer.shadowOpacity = .8f;
        self.inviteFriendsImageView.layer.shadowRadius = 10.0f;
        self.inviteFriendsImageView.layer.masksToBounds = NO;
        [self addSubview:self.inviteFriendsImageView];


        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tapGestureRecognizer];

        [self setUserInteractionEnabled:YES];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.inviteFriendsImageView.frame = CGRectInset(self.bounds, 20, 20);
}


- (void)handleTap {
    if (self.onInviteAction) {
        self.onInviteAction();
    }
}

@end