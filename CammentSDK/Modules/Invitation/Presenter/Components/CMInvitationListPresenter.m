//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <CammentSDK/CammentSDK.h>
#import "CMInvitationListPresenter.h"
#import "CMUser.h"
#import "CMFBFriendInvitationCellNode.h"
#import "CMFBFetchFrinedsInteractorInput.h"
#import "CMInvitationHeaderView.h"
#import "CMInvitationListSection.h"
#import "TLIndexPathSectionInfo.h"
#import <TLIndexPathUpdates.h>
#import <TLIndexPathDataModel.h>

@interface CMInvitationListPresenter ()
@property(nonatomic) BOOL isFetchingNextPage;
@property(nonatomic) TLIndexPathDataModel *dataModel;
@end

@implementation CMInvitationListPresenter {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = @[];
        _selectedUsersId = [NSMutableArray new];
        self.dataModel = [[TLIndexPathDataModel alloc] initWithItems:self.items];
    }
    return self;
}

- (void)setItemListDisplayNode:(ASTableNode *)node {
    self.tableNode = node;
    [self.tableNode setDisplaysAsynchronously:NO];
    [self.tableNode.view registerClass:[CMInvitationHeaderView class]
    forHeaderFooterViewReuseIdentifier:NSStringFromClass([CMInvitationHeaderView class])];
    [self.tableNode reloadData];
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CMUser *user = self.items[(NSUInteger) indexPath.row];

    if (user.status == CMUserStatusBusy) {
        [tableNode deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }

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
    [[self.interactor fetchFriendList:NO] subscribeNext:^(NSArray<CMUser *> *x) {
        [self appendUsersList:x];
        self.isFetchingNextPage = NO;
        [context completeBatchFetching:![self.interactor isFinished]];
    }                                             error:^(NSError *error) {
        self.isFetchingNextPage = NO;
        [context completeBatchFetching:NO];
    }];
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [self.dataModel numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return [self.dataModel numberOfSections];
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMUser *user = [self userForIndexPath:indexPath];
    BOOL selected = [self.selectedUsersId containsObject:user.fbUserId];
    return ^ASCellNode * {
        return [[CMFBFriendInvitationCellNode alloc] initWithUser:user selected:selected];
    };
}

- (void)setUsersList:(NSArray<CMUser *> *)users {
    self.items = [NSArray arrayWithArray:users];
    _selectedUsersId = [NSMutableArray new];
    [_tableNode reloadData];
}

- (void)appendUsersList:(NSArray<CMUser *> *)users {
    self.items = [_items arrayByAddingObjectsFromArray:users];

    // I'll keep it for future when we will split all the users
    // for sections by online status
//    TLIndexPathSectionInfo *onlineSection = [[TLIndexPathSectionInfo alloc]
//            initWithItems:[self filteredUsersForSection:CMInvitationListSectionOnline]
//                     name:CMLocalized(@"user_status.online")];
//
//    TLIndexPathSectionInfo *busySection = [[TLIndexPathSectionInfo alloc]
//            initWithItems:[self filteredUsersForSection:CMInvitationListSectionBusy]
//                     name:CMLocalized(@"user_status.busy")];
//
//    TLIndexPathSectionInfo *offlineSection = [[TLIndexPathSectionInfo alloc]
//            initWithItems:[self filteredUsersForSection:CMInvitationListSectionOffline]
//                     name:CMLocalized(@"user_status.offline")];
//
//    NSMutableArray<TLIndexPathSectionInfo *> *sections = [[NSMutableArray alloc] init];
//
//    if (onlineSection.numberOfObjects > 0) [sections addObject:onlineSection];
//    if (busySection.numberOfObjects > 0) [sections addObject:busySection];
//    if (offlineSection.numberOfObjects > 0) [sections addObject:offlineSection];
//
//    TLIndexPathDataModel *dataModel = [[TLIndexPathDataModel alloc]
//            initWithSectionInfos:sections
//               identifierKeyPath:nil];

    TLIndexPathDataModel *dataModel = [[TLIndexPathDataModel alloc] initWithItems:_items];
    [self updateDataModel:dataModel];
}

- (void)updateDataModel:(TLIndexPathDataModel *)dataModel {

    TLIndexPathDataModel *oldDataModel = self.dataModel;
    self.dataModel = dataModel;
    TLIndexPathUpdates *updates = [[TLIndexPathUpdates alloc] initWithOldDataModel:oldDataModel
                                                                  updatedDataModel:self.dataModel];

    [self.tableNode performBatchUpdates:^{

        if (updates.insertedSectionNames.count) {
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *sectionName in updates.insertedSectionNames) {
                NSInteger section = [updates.updatedDataModel sectionForSectionName:sectionName];
                [indexSet addIndex:(NSUInteger) section];
            }
            [self.tableNode insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }

        if (updates.deletedSectionNames.count) {
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *sectionName in updates.deletedSectionNames) {
                NSInteger section = [updates.oldDataModel sectionForSectionName:sectionName];
                [indexSet addIndex:(NSUInteger) section];
            }
            [self.tableNode deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        }

        if (updates.insertedItems.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (id item in updates.insertedItems) {
                NSIndexPath *indexPath = [updates.updatedDataModel indexPathForItem:item];
                [indexPaths addObject:indexPath];
            }
            [self.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }

        if (updates.deletedItems.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (id item in updates.deletedItems) {
                NSIndexPath *indexPath = [updates.oldDataModel indexPathForItem:item];
                [indexPaths addObject:indexPath];
            }
            [self.tableNode deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }

        if (updates.movedItems.count) {
            for (id item in updates.movedItems) {
                NSIndexPath *oldIndexPath = [updates.oldDataModel indexPathForItem:item];
                NSIndexPath *updatedIndexPath = [updates.updatedDataModel indexPathForItem:item];

                NSString *oldSectionName = [updates.oldDataModel sectionNameForSection:oldIndexPath.section];
                NSString *updatedSectionName = [updates.updatedDataModel sectionNameForSection:updatedIndexPath.section];
                BOOL oldSectionDeleted = [updates.deletedSectionNames containsObject:oldSectionName];
                BOOL updatedSectionInserted = [updates.insertedSectionNames containsObject:updatedSectionName];
                if (oldSectionDeleted && updatedSectionInserted) {
                } else if (oldSectionDeleted) {
                    [self.tableNode insertRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else if (updatedSectionInserted) {
                    [self.tableNode deleteRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableNode insertRowsAtIndexPaths:@[updatedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [self.tableNode moveRowAtIndexPath:oldIndexPath toIndexPath:updatedIndexPath];
                }

            }
        }
    }                        completion:^(BOOL finished) {

    }];
}

- (CMUser *)userForIndexPath:(NSIndexPath *)indexPath {
    return [self.dataModel itemAtIndexPath:indexPath];
};

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CMInvitationHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([CMInvitationHeaderView class])];

    if (!headerView) {
        headerView = [[CMInvitationHeaderView alloc] init];
    }

    [headerView configure:(CMInvitationListSection) section];

    return headerView;
}

- (CMUserStatus)userStatusForSection:(CMInvitationListSection)section {

    switch (section) {
        case CMInvitationListSectionOnline:
            return CMUserStatusOnline;
        case CMInvitationListSectionBusy:
            return CMUserStatusBusy;
        case CMInvitationListSectionOffline:
            return CMUserStatusOffline;
    }

    return CMUserStatusOffline;
};

- (NSArray <CMUser *> *)filteredUsersForSection:(CMInvitationListSection)section {
    CMUserStatus userStatus = [self userStatusForSection:section];
    return [self.items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status = %d", userStatus]];
};

@end
