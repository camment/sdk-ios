//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockPresenter.h"
#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "CMStore.h"
#import "CMAdsCell.h"
#import "NSArray+AWSMTLManipulationAdditions.h"

@interface CMCammentsBlockPresenter () <CMAdsCellDelegate>

@property (nonatomic, strong) NSOperationQueue *updatesQueue;

@end

@implementation CMCammentsBlockPresenter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = @[];
        
        self.updatesQueue = [[NSOperationQueue alloc] init];
        self.updatesQueue.underlyingQueue = dispatch_get_main_queue();
        self.updatesQueue.maxConcurrentOperationCount = 1;
        [self.updatesQueue setSuspended: NO];
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
    CammentsBlockItem *item = self.items[(NSUInteger) indexPath.row];
    return ^ASCellNode * {
        __block ASCellNode *node;
        [item matchCamment:^(Camment *camment) {
            node = [[CMCammentCell alloc] initWithCamment:camment];
        } ads:^(Ads *ads) {
            node = [[CMAdsCell alloc] initWithAds:ads];
            [(CMAdsCell *)node setDelegate:self];
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

    } completion:nil];
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(Camment *camment) {
        BOOL shouldPlay = ![camment.uuid isEqualToString: [[CMStore instance] playingCammentId]];
        [[CMStore instance] setPlayingCammentId:shouldPlay ? camment.uuid : kCMStoreCammentIdIfNotPlaying];
    } ads:^(Ads *ads) {
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ads.openURL]
                                           options:@{}
                                 completionHandler:nil];
    }];
}

- (void)insertNewItem:(CammentsBlockItem *)item {
    [self.updatesQueue addOperationWithBlock:^{
        [_collectionNode performBatchAnimated:YES updates:^{
            self.items = [@[item] arrayByAddingObjectsFromArray:[_items copy]];
            [_collectionNode insertItemsAtIndexPaths:@[
                                                       [NSIndexPath indexPathForItem:0 inSection:0]
                                                       ]];
        } completion:^(BOOL completed){
        }];
    }];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    __block CGSize result = CGSizeZero;

    CammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(Camment *camment) {
        result = camment.uuid == [CMStore instance].playingCammentId ? CGSizeMake(90.0f, 90.0f) : CGSizeMake(45.0f, 45.0f);
    } ads:^(Ads *ads) {
        result = CGSizeMake(45.0f, 45.0f);
    }];

    return ASSizeRangeMake(result);
}

- (void)adsCellDidTapOnCloseButton:(CMAdsCell *)cell {

    NSIndexPath *indexPath = [_collectionNode indexPathForNode:cell];
    if (indexPath && indexPath.row < _items.count && indexPath.row >= 0) {
        NSMutableArray *mutableItems = [_items mutableCopy];
        [mutableItems removeObjectAtIndex:(NSUInteger) indexPath.row];
        self.items = mutableItems;
        [_collectionNode performBatchAnimated:YES updates:^{
            [_collectionNode deleteItemsAtIndexPaths:@[
                    indexPath
            ]];
        } completion:nil];
    }
}

@end
