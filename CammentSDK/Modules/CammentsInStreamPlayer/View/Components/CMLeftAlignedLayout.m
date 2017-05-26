//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import "CMLeftAlignedLayout.h"


@implementation CMLeftAlignedLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributes = [[super layoutAttributesForElementsInRect:rect] copy];

    CGFloat leftMargin = self.sectionInset.left; //initalized to silence compiler, and actaully safer, but not planning to use.
    CGFloat maxY = -1.0f;

    //this loop assumes attributes are in IndexPath order
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        if (attribute.frame.origin.y >= maxY) {
            leftMargin = self.sectionInset.left;
        }

        attribute.frame = CGRectMake(leftMargin, attribute.frame.origin.y, attribute.frame.size.width, attribute.frame.size.height);

        leftMargin += attribute.frame.size.width + self.minimumInteritemSpacing;
        maxY = MAX(CGRectGetMaxY(attribute.frame), maxY);
    }

    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {

    if (itemIndexPath.row != 0) {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }

    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];

    attr.alpha = .0f;
    attr.frame = CGRectMake(self.sectionInset.left, -attr.bounds.size.height, attr.bounds.size.width, attr.bounds.size.height);

    return attr;
}

@end