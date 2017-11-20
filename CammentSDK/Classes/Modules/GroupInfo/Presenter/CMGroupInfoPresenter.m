//
//  CMGroupInfoCMGroupInfoPresenter.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import "CMGroupInfoPresenter.h"
#import "CMGroupInfoWireframe.h"
#import "CMStore.h"
#import "TLIndexPathDataModel.h"
#import "TLIndexPathUpdates.h"
#import "CMProfileViewNode.h"
#import "CMPeopleJoinedHeaderCell.h"
#import "CMGroupInfoUserCell.h"
#import "CMUserBuilder.h"
#import "CMInternalCammentSDKProtocol.h"
#import "CMUserSessionController.h"

typedef NS_ENUM(NSInteger, CMGroupInfoSection) {
    CMGroupInfoSectionUserProfile,
    CMGroupInfoInviteFriendsSection,
    CMGroupInfoFriendsHeaderSection,
};

@interface CMGroupInfoPresenter ()

@property(nonatomic, weak) ASCollectionNode *collectionNode;
@property(nonatomic) TLIndexPathDataModel *dataModel;
@property(nonatomic) NSArray<CMUser *> *users;
@property(nonatomic) BOOL showProfileInfo;

@end

@implementation CMGroupInfoPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataModel = [[TLIndexPathDataModel alloc] initWithItems:@[]];

        @weakify(self);
        [[[[CMStore instance].authentificationStatusSubject
                takeUntil:self.rac_willDeallocSignal] deliverOnMainThread]
                subscribeNext:^(CMAuthStatusChangedEventContext *x) {
                    @strongify(self);
                    self.showProfileInfo = x.state == CMCammentUserAuthentificatedAsKnownUser;
                    [self reloadData];
        }];
        
        [[[RACObserve([CMStore instance], activeGroupUsers)
                takeUntil:self.rac_willDeallocSignal]
                deliverOnMainThread] subscribeNext:^(NSArray *currentGroupUsers) {
            [self reloadData];
        }];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
};

- (void)reloadData {
    NSMutableArray *items = [NSMutableArray new];

    if (self.showProfileInfo) {
        [items addObject:@(CMGroupInfoSectionUserProfile)];
    }

    self.users = [[CMStore instance].activeGroupUsers.rac_sequence filter:^BOOL(CMUser *user) {
        return ![user.cognitoUserId isEqualToString:user.cognitoUserId];
    }].array ?: @[];

    if (self.users.count == 0) {
        [items addObject:@(CMGroupInfoInviteFriendsSection)];
    } else {
        [items addObject:@(CMGroupInfoFriendsHeaderSection)];
        [items addObjectsFromArray:self.users];
    }

    TLIndexPathDataModel *updatedModel = [[TLIndexPathDataModel alloc] initWithItems:items];
    [self updateDataModel:updatedModel];
}

- (void)setupView {
    [self reloadData];
}

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    self.collectionNode = node;
    [self reloadData];
}

- (void)layoutCollectionViewIfNeeded {
    [self.collectionNode invalidateCalculatedLayout];
    [self.collectionNode reloadData];
}

- (void)inviteFriendsGroupInfoNodeDidTapLearnMoreButton:(CMInviteFriendsGroupInfoNode *)node {
    NSURL *infoURL = [[NSURL alloc] initWithString:@"http://camment.tv"];
    id<CMInternalCammentSDKProtocol> SDK = (id)[CammentSDK instance];
    [SDK openURL:infoURL];
}

- (void)inviteFriendsGroupInfoDidTapInviteFriendsButton:(CMInviteFriendsGroupInfoNode *)node {
    [[[CMStore instance] inviteFriendsActionSubject] sendNext:@YES];
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.dataModel numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return [self.dataModel numberOfSections];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    __block ASCellNodeBlock cellNodeBlock = nil;

    id model = [self.dataModel itemAtIndexPath:indexPath];

    if ([model isKindOfClass:[NSNumber class]]) {
        CMGroupInfoSection section = (CMGroupInfoSection) [model integerValue];
        switch (section) {
            case CMGroupInfoSectionUserProfile: {
                cellNodeBlock = ^ASCellNode *() {
                    return [CMProfileViewNode new];
                };
                break;
            }
            case CMGroupInfoInviteFriendsSection:{
                cellNodeBlock = ^ASCellNode *() {
                    CMInviteFriendsGroupInfoNode *inviteFriendsGroupInfoNode = [CMInviteFriendsGroupInfoNode new];
                    inviteFriendsGroupInfoNode.delegate = weakSelf;
                    return inviteFriendsGroupInfoNode;
                };
                break;
            }
            case CMGroupInfoFriendsHeaderSection: {
                cellNodeBlock = ^ASCellNode *() {
                    return [CMPeopleJoinedHeaderCell new];
                };
                break;
            }
                
        }
    } else {
        CMUser *user = model;
        cellNodeBlock = ^ASCellNode *() {
            return [[CMGroupInfoUserCell alloc] initWithUser:user];
        };
    }

    return cellNodeBlock;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    return result;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    id model = [self.dataModel itemAtIndexPath:indexPath];

    if ([model isKindOfClass:[NSNumber class]]) {
        CMGroupInfoSection section = (CMGroupInfoSection) [model integerValue];
        if (section == CMGroupInfoInviteFriendsSection) {
            CGSize size;
            CGFloat profileCellHeight = 100.0f;

            if (self.showProfileInfo) {
                profileCellHeight = [[CMProfileViewNode new] layoutThatFits:ASSizeRangeMake(CGSizeMake(collectionNode.bounds.size.width, .0f),
                                                                                        CGSizeMake(collectionNode.bounds.size.width, CGFLOAT_MAX))].size.height;
            }
            profileCellHeight += 20.0f;
            size = CGSizeMake(collectionNode.frame.size.width, collectionNode.frame.size.height - (_showProfileInfo ? profileCellHeight : .0f));
            
            return ASSizeRangeMake(size);
        }
    }

    return ASSizeRangeMake(CGSizeMake(collectionNode.bounds.size.width, .0f),
            CGSizeMake(collectionNode.bounds.size.width, CGFLOAT_MAX));
}


- (void)updateDataModel:(TLIndexPathDataModel *)dataModel {
    TLIndexPathDataModel *oldDataModel = self.dataModel;
    self.dataModel = dataModel;

    TLIndexPathUpdates *updates = [[TLIndexPathUpdates alloc] initWithOldDataModel:oldDataModel
                                                                  updatedDataModel:self.dataModel];

    [self.collectionNode performBatchUpdates:^{

        if (updates.insertedSectionNames.count) {
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *sectionName in updates.insertedSectionNames) {
                NSInteger section = [updates.updatedDataModel sectionForSectionName:sectionName];
                [indexSet addIndex:(NSUInteger) section];
            }
            [self.collectionNode insertSections:indexSet];
        }

        if (updates.deletedSectionNames.count) {
            NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
            for (NSString *sectionName in updates.deletedSectionNames) {
                NSInteger section = [updates.oldDataModel sectionForSectionName:sectionName];
                [indexSet addIndex:(NSUInteger) section];
            }
            [self.collectionNode deleteSections:indexSet];
        }

        if (updates.insertedItems.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (id item in updates.insertedItems) {
                NSIndexPath *indexPath = [updates.updatedDataModel indexPathForItem:item];
                [indexPaths addObject:indexPath];
            }
            [self.collectionNode insertItemsAtIndexPaths:indexPaths];
        }

        if (updates.deletedItems.count) {
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (id item in updates.deletedItems) {
                NSIndexPath *indexPath = [updates.oldDataModel indexPathForItem:item];
                [indexPaths addObject:indexPath];
            }
            [self.collectionNode deleteItemsAtIndexPaths:indexPaths];
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
                    [self.collectionNode insertItemsAtIndexPaths:@[updatedIndexPath]];
                } else if (updatedSectionInserted) {
                    [self.collectionNode deleteItemsAtIndexPaths:@[oldIndexPath]];
                    [self.collectionNode insertItemsAtIndexPaths:@[updatedIndexPath]];
                } else {
                    [self.collectionNode moveItemAtIndexPath:oldIndexPath toIndexPath:updatedIndexPath];
                }

            }
        }
    }                        completion:^(BOOL finished) {

    }];
}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFailToFetchUsersInGroup:(NSError *)group {

}

- (void)groupInfoInteractor:(id <CMGroupInfoInteractorInput>)interactor didFetchUsers:(NSArray<CMUser *> *)users inGroup:(NSString *)group {

}

@end
