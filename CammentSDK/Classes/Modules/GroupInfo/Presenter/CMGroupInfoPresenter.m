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

typedef NS_ENUM(NSInteger, CMGroupInfoSection) {
    CMGroupInfoSectionUserProfile,
    CMGroupInfoInviteFriendsSection,
};

@interface CMGroupInfoPresenter ()

@property(nonatomic, weak) ASCollectionNode *collectionNode;
@property(nonatomic) TLIndexPathDataModel *dataModel;
@property(nonatomic) NSArray<CMUser *> *users;
@property(nonatomic) BOOL showProfileInfo;
@property(nonatomic, strong) CMProfileViewNode *profileViewNode;
@end

@implementation CMGroupInfoPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataModel = [[TLIndexPathDataModel alloc] initWithItems:@[]];
        self.profileViewNode = [CMProfileViewNode new];
        @weakify(self);
        [[[RACObserve([CMStore instance], isFBConnected)
                takeUntil:self.rac_willDeallocSignal]
                deliverOnMainThread] subscribeNext:^(NSNumber *isFBConnected) {
            @strongify(self);
            self.showProfileInfo = isFBConnected.boolValue;
            [self reloadData];
        }];
    }

    return self;
}

- (void)reloadData {
    NSMutableArray *items = [NSMutableArray new];

    if (self.showProfileInfo) {
        [items addObject:@(CMGroupInfoSectionUserProfile)];
    }

    if (self.users.count == 0) {
        [items addObject:@(CMGroupInfoInviteFriendsSection)];
    } else {
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
    [self.collectionNode reloadData];
}

- (void)inviteFriendsGroupInfoNodeDidTapLearnMoreButton:(CMInviteFriendsGroupInfoNode *)node {
    NSURL *infoURL = [[NSURL alloc] initWithString:@"http://camment.tv"];
    [[UIApplication sharedApplication] openURL:infoURL
                                       options:@{}
                             completionHandler:nil];
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
                CMProfileViewNode *profileNode = self.profileViewNode;
                cellNodeBlock = ^ASCellNode *() {
                    return profileNode ?: [ASCellNode new];
                };
                break;
            }
            case CMGroupInfoInviteFriendsSection:
                cellNodeBlock = ^ASCellNode *() {
                    CMInviteFriendsGroupInfoNode *inviteFriendsGroupInfoNode = [CMInviteFriendsGroupInfoNode new];
                    inviteFriendsGroupInfoNode.delegate = weakSelf;
                    return inviteFriendsGroupInfoNode;
                };
                break;
        }
    } else {

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

            if (self.profileViewNode) {
                profileCellHeight = [self.profileViewNode layoutThatFits:ASSizeRangeMake(CGSizeMake(collectionNode.bounds.size.width, .0f),
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
@end
