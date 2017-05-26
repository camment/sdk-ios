//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMCammentsBlockPresenter.h"
#import "Camment.h"
#import "CMCammentCell.h"
#import "CMCammentNode.h"
#import "CMStore.h"
#import <ReactiveObjC/ReactiveObjC.h>

@implementation CMCammentsBlockPresenter

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    _collectionNode = node;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.camments count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    Camment *camment = self.camments[(NSUInteger) indexPath.row];
    return ^ASCellNode * {
        return [[CMCammentCell alloc] initWithCamment:camment];
    };
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
    return result;
}

- (void)playCamment:(NSInteger)cammentId {
    [_collectionNode.collectionViewLayout invalidateLayout];
    [_collectionNode performBatchAnimated:YES updates:^{
        [_collectionNode.visibleNodes.rac_sequence map:^id(CMCammentCell *cammentCell) {
            BOOL oldExpandedValue = cammentCell.expanded;
            BOOL shouldPlay =
                    cammentCell.cammentNode.camment.cammentId == cammentId
                            && !cammentCell.cammentNode.isPlaying;
            cammentCell.expanded = shouldPlay;
            if (oldExpandedValue != cammentCell.expanded) {
                [cammentCell transitionLayoutWithAnimation:YES shouldMeasureAsync:NO measurementCompletion:nil];
            }
            if (shouldPlay) {
                [cammentCell.cammentNode playCamment];
            } else {
                [cammentCell.cammentNode stopCamment];
            }
            return cammentCell;
        }].array;
    } completion:nil];
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Camment *camment = self.camments[(NSUInteger) indexPath.row];
    BOOL shouldPlay = camment.cammentId != [[CMStore instance] playingCammentId];
    [[CMStore instance] setPlayingCammentId:shouldPlay ? camment.cammentId : kCMStoreCammentIdIfNotPlaying];
}

- (void)insertNewCamment:(Camment *)camment {
    _camments = [@[camment] arrayByAddingObjectsFromArray:_camments];
    [_collectionNode performBatchAnimated:YES updates:^{
        [_collectionNode insertItemsAtIndexPaths:@[
                [NSIndexPath indexPathForItem:0 inSection:0]
        ]];
    } completion:nil];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize result = CGSizeZero;

    Camment *camment = self.camments[(NSUInteger) indexPath.row];
    result = camment.cammentId == [CMStore instance].playingCammentId ? CGSizeMake(90.0f, 90.0f) : CGSizeMake(45.0f, 45.0f);

    return ASSizeRangeMake(result);
}


@end
