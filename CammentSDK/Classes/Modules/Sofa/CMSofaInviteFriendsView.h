//
// Created by Alexander Fedosov on 20/08/2018.
//

#import <Foundation/Foundation.h>


@interface CMSofaInviteFriendsView : UIView

@property (nonatomic, strong) UIImageView * inviteFriendsImageView;
@property (nonatomic, copy) dispatch_block_t onInviteAction;

@end