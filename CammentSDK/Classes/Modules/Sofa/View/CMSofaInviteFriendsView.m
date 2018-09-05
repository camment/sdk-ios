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
        self.alpha = .8f;

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

        self.activityIndicator = [CMActivityIndicator new];
        self.activityIndicator.layer.shadowColor = [UIColor blackColor].CGColor;
        self.activityIndicator.layer.shadowOffset = CGSizeMake(.0f, .0f);
        self.activityIndicator.layer.shadowOpacity = .8f;
        self.activityIndicator.layer.shadowRadius = 10.0f;
        self.activityIndicator.layer.masksToBounds = NO;
        [self addSubview:self.activityIndicator];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tapGestureRecognizer];

        [self hideActivityIndicator];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.inviteFriendsImageView.frame = CGRectInset(self.bounds, 20, 20);
    self.activityIndicator.frame = self.inviteFriendsImageView.frame;
}


- (void)handleTap {
    if (self.onInviteAction) {
        self.onInviteAction();
    }
}

- (void)showActivityIndicator {
    self.inviteFriendsImageView.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimation];
    self.userInteractionEnabled = NO;
}

- (void)hideActivityIndicator {
    self.inviteFriendsImageView.hidden = NO;
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimation];
    self.userInteractionEnabled = YES;
}

@end
