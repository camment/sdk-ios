//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMFBFriendInvitationCellNode.h"
#import "CMUser.h"

@interface CMFBFriendInvitationCellNode ()
@property(nonatomic, strong) ASTextNode *nameTextNode;
@property(nonatomic, strong) ASNetworkImageNode *userPhotoImageNode;
@end

@implementation CMFBFriendInvitationCellNode

- (instancetype)initWithUser:(CMUser *)user selected:(BOOL)selected {
    self = [super init];
    if (self) {
        self.nameTextNode = [ASTextNode new];
        [self.nameTextNode setAttributedText:[[NSAttributedString alloc] initWithString:user.username]];

        self.userPhotoImageNode = [ASNetworkImageNode new];
        self.userPhotoImageNode.URL = [[NSURL alloc] initWithString:user.userPhoto];
        self.userPhotoImageNode.style.preferredSize = CGSizeMake(40, 40);
        self.userPhotoImageNode.cornerRadius = 20.0f;
        self.userPhotoImageNode.clipsToBounds = YES;
        self.userPhotoImageNode.backgroundColor = [UIColor lightGrayColor];

        [self setAccessoryType:selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASInsetLayoutSpec *userPicInsetLayout = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 0, 0, 10) child:_userPhotoImageNode];

    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec
            stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                 spacing:0
                          justifyContent:ASStackLayoutJustifyContentStart
                              alignItems:ASStackLayoutAlignItemsCenter
                                children:@[userPicInsetLayout, _nameTextNode]];

    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 40)
                                                  child:[ASWrapperLayoutSpec wrapperWithLayoutElement:stackLayoutSpec]];
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];
}


@end
