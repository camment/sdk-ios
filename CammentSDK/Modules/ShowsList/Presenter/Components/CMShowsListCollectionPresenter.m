//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMShowsListCollectionPresenter.h"
#import "CMShow.h"
#import "CMShowCellNode.h"
#import "Show.h"
#import "CMVideoShowCellNode.h"
#import "CMHtmlShowCellNode.h"


@implementation CMShowsListCollectionPresenter

- (void)setItemCollectionDisplayNode:(ASCollectionNode *)node {
    _collectionNode = node;
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return [self.shows count];
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    return 1;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    Show *show = self.shows[(NSUInteger) indexPath.row];

    __block ASCellNodeBlock cellNodeBlock = nil;

    [show.showType matchVideo:^(CMShow *show) {
        cellNodeBlock = ^ASCellNode * {
            return [[CMVideoShowCellNode alloc] initWithShow:show];
        };
    } html:^(NSString *webURL) {
        cellNodeBlock = ^ASCellNode * {
            return [[CMHtmlShowCellNode alloc] initWithShow:show];
        };
    }];

    return cellNodeBlock;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(2.0f, 0.0f, 2.0f, 0.0f);
    return result;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Show *show = self.shows[(NSUInteger) indexPath.row];
    [self.output didSelectShow: show];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize result = CGSizeMake(collectionNode.bounds.size.width, collectionNode.bounds.size.width / 16 * 9);
    return ASSizeRangeMake(result);
}


@end
