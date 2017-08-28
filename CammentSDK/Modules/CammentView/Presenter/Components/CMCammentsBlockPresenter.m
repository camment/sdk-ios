//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockPresenter.h"
#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "CMStore.h"
#import "CMAdsCell.h"

@interface CMCammentsBlockPresenter () <CMAdsCellDelegate, CMCammentCellDelegate>

@property(nonatomic, strong) NSOperationQueue *updatesQueue;

@end

@implementation CMCammentsBlockPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = @[];

        self.updatesQueue = [[NSOperationQueue alloc] init];
        self.updatesQueue.underlyingQueue = dispatch_get_main_queue();
        self.updatesQueue.maxConcurrentOperationCount = 1;
        [self.updatesQueue setSuspended:NO];
    }

    return self;
}

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    _collectionNode = node;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMCammentsBlockItem *item = self.items[(NSUInteger) indexPath.row];
    return ^ASCellNode * {
        __block ASCellNode *node;
        [item matchCamment:^(CMCamment *camment) {
            node = [[CMCammentCell alloc] initWithCamment:camment];
            [(CMCammentCell *) node setDelegate:self];
        }              ads:^(CMAds *ads) {
            node = [[CMAdsCell alloc] initWithAds:ads];
            [(CMAdsCell *) node setDelegate:self];
        }];

        return node;
    };
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    return result;
}

- (void)playCamment:(NSString *)cammentId {
    [_collectionNode.collectionViewLayout invalidateLayout];
    [_collectionNode performBatchAnimated:YES updates:^{
        for (ASCellNode *node in _collectionNode.visibleNodes) {
            if (![node isKindOfClass:[CMCammentCell class]]) {continue;}

            CMCammentCell *cammentCell = (CMCammentCell *) node;
            BOOL oldExpandedValue = cammentCell.expanded;
            BOOL shouldPlay = [cammentCell.cammentNode.camment.uuid isEqualToString:cammentId] && !cammentCell.cammentNode.isPlaying;

            cammentCell.expanded = shouldPlay;
            if (oldExpandedValue != cammentCell.expanded) {
                [cammentCell transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
            }
            if (shouldPlay) {
                [cammentCell.cammentNode playCamment];
            } else {
                [cammentCell.cammentNode stopCamment];
            }
        }

    }                          completion:nil];
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMCammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(CMCamment *camment) {
        BOOL shouldPlay = ![camment.uuid isEqualToString:[[CMStore instance] playingCammentId]];
        [[CMStore instance] setPlayingCammentId:shouldPlay ? camment.uuid : kCMStoreCammentIdIfNotPlaying];
    }                           ads:^(CMAds *ads) {
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ads.openURL]
                                           options:@{}
                                 completionHandler:nil];
    }];
}

- (void)insertNewItem:(CMCammentsBlockItem *)item completion:(void (^)())completion {
    [self.updatesQueue addOperationWithBlock:^{
        [_collectionNode performBatchAnimated:YES updates:^{
            self.items = [@[item] arrayByAddingObjectsFromArray:[_items copy]];
            [_collectionNode insertItemsAtIndexPaths:@[
                    [NSIndexPath indexPathForItem:0 inSection:0]
            ]];
        }                          completion:^(BOOL completed) {
            if (completion) {
                completion();
            }
        }];
    }];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    __block CGSize result = CGSizeZero;

    CMCammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(CMCamment *camment) {
        result = camment.uuid == [CMStore instance].playingCammentId ? CGSizeMake(90.0f, 90.0f) : CGSizeMake(45.0f, 45.0f);
    }                           ads:^(CMAds *ads) {
        result = CGSizeMake(45.0f, 45.0f);
    }];

    return ASSizeRangeMake(result);
}

- (void)adsCellDidTapOnCloseButton:(CMAdsCell *)cell {

    NSIndexPath *indexPath = [_collectionNode indexPathForNode:cell];
    [self removeItemAtIndexPath:indexPath];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath && indexPath.row < _items.count && indexPath.row >= 0) {
        NSMutableArray *mutableItems = [[NSMutableArray alloc] initWithArray:_items copyItems:YES];
        [mutableItems removeObjectAtIndex:(NSUInteger) indexPath.row];
        self.items = mutableItems;
        [_collectionNode performBatchAnimated:YES updates:^{
            [_collectionNode deleteItemsAtIndexPaths:@[
                    indexPath
            ]];
        }                          completion:nil];
    }
}

- (void)cammentCellDidHandleLongPressAction:(CMCammentCell *)cell {
    if (self.output && [self.output respondsToSelector:@selector(presentCammentOptionsDialog:)]) {
        [self.output presentCammentOptionsDialog:cell];
    }
}

- (void)deleteItem:(CMCammentsBlockItem *)blockItem {
    for (NSUInteger i = 0; i < self.items.count; i++) {
        CMCammentsBlockItem *item = self.items[i];
        [blockItem matchCamment:^(CMCamment *camment) {
            [item matchCamment:^(CMCamment *itemCamment) {
                if ([camment.uuid isEqualToString:itemCamment.uuid])
                    [self removeItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }              ads:^(CMAds *ads) {
            }];
        }                   ads:^(CMAds *ads) {
        }];
    }
}

- (void)reloadItems:(NSArray<CMCammentsBlockItem *> *)newItems animated:(BOOL)animated {
    if (!animated) {
        self.items = newItems;
        [self.collectionNode reloadData];
    } else {
        NSMutableArray<NSIndexPath *> *itemsToRemove = [NSMutableArray new];
        NSMutableArray<NSIndexPath *> *itemsToInsert = [NSMutableArray new];

        for (int i = 0; i < _items.count; i++) {
            [itemsToRemove addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }

        for (int i = 0; i < newItems.count; i++) {
            [itemsToInsert addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }

        self.items = newItems;
        [self.collectionNode performBatchAnimated:YES
                                          updates:^{
                                              if ([itemsToRemove count] > 0) {
                                                  [self.collectionNode deleteItemsAtIndexPaths:itemsToRemove];
                                              }

                                              if ([itemsToInsert count] > 0) {
                                                  [self.collectionNode insertItemsAtIndexPaths:itemsToInsert];
                                              }
                                          }
                                       completion:^(BOOL finished) {}];
    }
}


@end
