//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockPresenter.h"
#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "CMStore.h"
#import "CMAdsCell.h"

@implementation CMCammentsBlockPresenter

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
            BOOL shouldPlay = [cammentCell.cammentNode.camment.cammentUUID isEqualToString:cammentId] && !cammentCell.cammentNode.isPlaying;
        
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
        BOOL shouldPlay = ![camment.cammentUUID isEqualToString: [[CMStore instance] playingCammentId]];
        [[CMStore instance] setPlayingCammentId:shouldPlay ? camment.cammentUUID : kCMStoreCammentIdIfNotPlaying];
    } ads:^(Ads *ads) {
        [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ads.openURL]
                                           options:@{}
                                 completionHandler:nil];
    }];
}

- (void)insertNewItem:(CammentsBlockItem *)item {
    _items = [@[item] arrayByAddingObjectsFromArray:_items];
    [_collectionNode performBatchAnimated:YES updates:^{
        [_collectionNode insertItemsAtIndexPaths:@[
                [NSIndexPath indexPathForItem:0 inSection:0]
        ]];
    } completion:nil];

    if (_items.count == 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *filepath = [[NSBundle bundleForClass:[self class]] pathForResource:@"ads" ofType:@"gif"];
            NSURL *url = [NSURL fileURLWithPath:filepath];
            CammentsBlockItem *ads = [CammentsBlockItem adsWithAds:[[Ads alloc] initWithURL:url.absoluteString
                                                                                    openURL:@"http://wolt.com"]];
            [self insertNewItem:ads];
        });
    }
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    __block CGSize result = CGSizeZero;

    CammentsBlockItem *cammentsBlockItem = self.items[(NSUInteger) indexPath.row];
    [cammentsBlockItem matchCamment:^(Camment *camment) {
        result = camment.cammentUUID == [CMStore instance].playingCammentId ? CGSizeMake(90.0f, 90.0f) : CGSizeMake(45.0f, 45.0f);
    } ads:^(Ads *ads) {
        result = CGSizeMake(45.0f, 45.0f);
    }];

    return ASSizeRangeMake(result);
}


@end
