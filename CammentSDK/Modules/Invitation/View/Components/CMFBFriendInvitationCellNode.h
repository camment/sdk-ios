//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/ASCellNode.h>


@class User;

@interface CMFBFriendInvitationCellNode : ASCellNode


- (instancetype)initWithUser:(User *)user selected:(BOOL)selected;
@end