//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMInvitationListPresenter.h"
#import "User.h"
#import "CMFBFriendInvitationCellNode.h"
#import "UserBuilder.h"
#import "CMFBFetchFrinedsInteractorInput.h"
#import "RACSignal.h"

@interface CMInvitationListPresenter ()
@property(nonatomic) BOOL isFetchingNextPage;
@end

@implementation CMInvitationListPresenter {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = @[];
        _selectedUsersId = [NSMutableArray new];
    }
    return self;
}

- (void)setItemListDisplayNode:(ASTableNode *)node {
    self.tableNode = node;
    [self.tableNode reloadData];
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.items[(NSUInteger) indexPath.row];
    if ([self.selectedUsersId containsObject:user.fbUserId]) {
        [self.selectedUsersId removeObject:user.fbUserId];
    } else {
        [self.selectedUsersId addObject:user.fbUserId];
    }
    [tableNode reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return !self.isFetchingNextPage;
}

- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    self.isFetchingNextPage = YES;

    [context beginBatchFetching];
    [[self.interactor fetchFriendList:NO] subscribeNext:^(NSArray<User *> *x) {
        [self appendUsersList:x];
        self.isFetchingNextPage = NO;
        [context completeBatchFetching:![self.interactor isFinished]];
    } error:^(NSError *error) {
        self.isFetchingNextPage = NO;
        [context completeBatchFetching:NO];
    }];
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user = self.items[(NSUInteger) indexPath.row];
    BOOL selected = [self.selectedUsersId containsObject:user.fbUserId];
    return ^ASCellNode * {
        return [[CMFBFriendInvitationCellNode alloc] initWithUser:user selected:selected];
    };
}

- (void)setUsersList:(NSArray<User *> *)users {
    self.items = [NSArray arrayWithArray:users];
    _selectedUsersId = [NSMutableArray new];
    [_tableNode reloadData];
}

- (void)appendUsersList:(NSArray<User *> *)users {
    self.items = [_items arrayByAddingObjectsFromArray:users];
    NSMutableArray *indexPathesToAdd = [NSMutableArray new];
    for (NSInteger i = _items.count - users.count; i < _items.count; i++) {
        [indexPathesToAdd addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [_tableNode insertRowsAtIndexPaths:indexPathesToAdd withRowAnimation:UITableViewRowAnimationBottom];
}


@end
