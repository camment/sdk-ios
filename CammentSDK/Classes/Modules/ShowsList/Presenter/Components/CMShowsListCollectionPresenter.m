//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMShowsListCollectionPresenter.h"
#import "CMAPIShow.h"
#import "CMShowCellNode.h"
#import "CMShow.h"
#import "CMVideoShowCellNode.h"
#import "CMHtmlShowCellNode.h"
#import "NSArray+RacSequence.h"
#import "CMNoShowsCellNode.h"
#import "TLIndexPathDataModel.h"
#import "TLIndexPathUpdates.h"
#import "CMShowListHeaderCell.h"


@interface CMShowsListCollectionPresenter () <CMShowCellNodeDelegate>

@property(nonatomic) TLIndexPathDataModel *showsDataModel;
@property(nonatomic) TLIndexPathDataModel *noShowsDataModel;
@property(nonatomic) TLIndexPathDataModel *dataModel;

@end

@implementation CMShowsListCollectionPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showsDataModel = [[TLIndexPathDataModel alloc] initWithItems:[@[@0] arrayByAddingObjectsFromArray:self.shows]];
        self.noShowsDataModel = [[TLIndexPathDataModel alloc] initWithItems:@[@0, @YES]];
        self.dataModel = self.showsDataModel;
    }
    
    return self;
}

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    _collectionNode = node;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.dataModel numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return [self.dataModel numberOfSections];
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        return ^ASCellNode * {
            CMShowListHeaderCell * cell = [CMShowListHeaderCell new];
            cell.delegate = weakSelf;
            return cell;
        };
    }

    if (_showNoShowsNode) {
        return ^ASCellNode * {
            return [CMNoShowsCellNode new];
        };
    }

    CMShow *show = self.shows[(NSUInteger) indexPath.row - 1];

    __block ASCellNodeBlock cellNodeBlock = nil;

    [show.showType matchVideo:^(CMAPIShow *underlyingShow) {
        cellNodeBlock = ^ASCellNode * {
            CMVideoShowCellNode *node = [[CMVideoShowCellNode alloc] initWithShow:show];
            node.delegate = weakSelf;
            return node;
        };
    } html:^(NSString *webURL) {
        cellNodeBlock = ^ASCellNode * {
            CMHtmlShowCellNode *node =  [[CMHtmlShowCellNode alloc] initWithShow:show];
            node.delegate = weakSelf;
            return node;
        };
    }];

    return cellNodeBlock;
}

- (void)setShowNoShowsNode:(BOOL)showNoShowsNode {
    _showNoShowsNode = showNoShowsNode;
    [self updateDataModel:_showNoShowsNode ? _noShowsDataModel : _showsDataModel];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    return result;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) { return; }
    if (_showNoShowsNode) { return; }
    CMShow *show = self.shows[(NSUInteger) indexPath.row - 1];
    CMShowCellNode *node = [collectionNode nodeForItemAtIndexPath:indexPath];
    [self.output didSelectShow:show rect:[collectionNode convertRect:node.frame fromNode:node] image:[node thumbnailImage]];
}

- (void)showCellNode:(CMShowCellNode *)node didSelectShow:(CMShow *)show {
    if (_showNoShowsNode) { return; }
    [self.output didSelectShow:show rect:[node convertRect:node.frame toNode:nil] image:[node thumbnailImage]];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return ASSizeRangeMake(CGSizeMake(collectionNode.bounds.size.width - 40, 74.0f));
    }

    CGSize result;

    if (_showNoShowsNode) {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            CGFloat side = (collectionNode.bounds.size.width - 110) / 3 * 2;
            result = CGSizeMake(side, side);
        } else {
            CGFloat side = (collectionNode.bounds.size.width - 40);
            result = CGSizeMake(side, collectionNode.bounds.size.height / 2);
        }
    } else {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            CGFloat side = (collectionNode.bounds.size.width - 110) / 3;
            result = CGSizeMake(side, side);
        } else {
            CGFloat side = (collectionNode.bounds.size.width - 40);
            result = CGSizeMake(side, side / 16 * 9);
        }
    }
    
    return ASSizeRangeMake(result);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    ASCollectionNode *collectionNode = (id) scrollView;
    [[collectionNode visibleNodes] map:^id(ASCellNode *node) {
        if ([node isKindOfClass:[CMShowCellNode class]]) {
            [(CMShowCellNode *)node cancelTapGesture];
        }
        return nil;
    }];
}

- (void)setShows:(NSArray<CMShow *> *)shows {
    _shows = shows;
    self.showsDataModel = [[TLIndexPathDataModel alloc] initWithItems:[@[@0] arrayByAddingObjectsFromArray:_shows]];
    [self updateDataModel:_showNoShowsNode ? _noShowsDataModel : _showsDataModel];
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

- (void)reloadShows {

}

- (void)showTweaksView {
    [self.output showTweaksView];
}

- (void)showPasscodeView {
    [self.output showPasscodeView];
}

@end
