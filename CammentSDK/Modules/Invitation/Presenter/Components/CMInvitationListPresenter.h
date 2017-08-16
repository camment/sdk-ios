//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMInvitationNode.h"


@class CMUser;
@protocol CMFBFetchFrinedsInteractorInput;

@interface CMInvitationListPresenter : NSObject<CMInvitationListDelegate>

@property (nonatomic, strong) NSArray<CMUser *> *items;
@property (nonatomic, strong, readonly) NSMutableArray<NSString *> *selectedUsersId;
@property (nonatomic, weak) ASTableNode *tableNode;

@property (nonatomic, weak) id<CMFBFetchFrinedsInteractorInput> interactor;

- (void)appendUsersList:(NSArray<CMUser *> *)users;

@end
