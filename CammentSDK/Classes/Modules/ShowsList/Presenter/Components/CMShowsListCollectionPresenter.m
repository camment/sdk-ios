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


@interface CMShowsListCollectionPresenter () <CMShowCellNodeDelegate>
@end

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

    __weak typeof(self) weakSelf = self;
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets result = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    return result;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CMShow *show = self.shows[(NSUInteger) indexPath.row];
    CMShowCellNode *node = [collectionNode nodeForItemAtIndexPath:indexPath];
    [self.output didSelectShow:show rect:[collectionNode convertRect:node.frame fromNode:node] image:[node thumbnailImage]];
}

- (void)showCellNode:(CMShowCellNode *)node didSelectShow:(CMShow *)show {
    [self.output didSelectShow:show rect:[node convertRect:node.frame toNode:nil] image:[node thumbnailImage]];
}

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize result;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGFloat side = (collectionNode.bounds.size.width - 110) / 3;
        result = CGSizeMake(side, side);
    } else {
        CGFloat side = (collectionNode.bounds.size.width - 40);
        result = CGSizeMake(side, side / 16 * 9);
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

@end
