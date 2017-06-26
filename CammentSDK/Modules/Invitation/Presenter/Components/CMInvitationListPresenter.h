//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMInvitationNode.h"


@class User;
@protocol CMFBFetchFrinedsInteractorInput;

@interface CMInvitationListPresenter : NSObject<CMInvitationListDelegate>

@property (nonatomic, strong, readonly) NSArray<User *> *items;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *selectedUsersId;
@property (nonatomic, weak) ASTableNode *tableNode;

@property (nonatomic, weak) id<CMFBFetchFrinedsInteractorInput> interactor;

- (void)setUsersList:(NSArray<User *> *)users;
- (void)appendUsersList:(NSArray<User *> *)users;

@end