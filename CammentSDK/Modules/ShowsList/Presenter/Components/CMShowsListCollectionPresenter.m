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
    CMShow *show = self.shows[(NSUInteger) indexPath.row];

    __block ASCellNodeBlock cellNodeBlock = nil;

    [show.showType matchVideo:^(CMAPIShow *underlyingShow) {
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
    UIEdgeInsets result = UIEdgeInsetsMake(4.0f, 4.0f, 4.0f, 4.0f);
    return result;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMShow *show = self.shows[(NSUInteger) indexPath.row];
    [self.output didSelectShow: show];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize result;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat side = (collectionNode.bounds.size.width - 20)/ 3;
        result = CGSizeMake(side, side);
    } else {
        result = CGSizeMake(collectionNode.bounds.size.width, collectionNode.bounds.size.width / 16 * 9);
    }
    
    return ASSizeRangeMake(result);
}


@end
