//
// Created by Alexander Fedosov on 06.11.2017.
//

#import "CMLeftAlignedLayoutDelegate.h"
#import "CMCammentCell.h"
#import "CMCamment.h"
#import "CMStore.h"
#import "ASCollectionElement.h"
#import "CMCammentCellDisplayingContext.h"

@implementation CMLeftAlignedLayoutDelegate {

}

- (ASScrollDirection)scrollableDirections {
    return ASScrollDirectionVerticalDirections;
}

- (nullable id)additionalInfoForLayoutWithElements:(ASElementMap *)elements {
    return nil;
}

+ (ASCollectionLayoutState *)calculateLayoutWithContext:(ASCollectionLayoutContext *)context {
    CGFloat layoutWidth = context.viewportSize.width;
    ASElementMap *elements = context.elements;
    CGFloat top = 0;

    NSMapTable<ASCollectionElement *, UICollectionViewLayoutAttributes *> *attrsMap = [NSMapTable elementToLayoutAttributesTable];
    NSInteger numberOfSections = [elements numberOfSections];

    for (NSUInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [elements numberOfItemsInSection:section];
        for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
            if ([element.node isKindOfClass:[CMCammentCell class]]) {
                CMCammentCell *cell = (CMCammentCell *)element.node;
                BOOL isFirst = section == 0 && idx == 0;
                BOOL isLast = section == numberOfSections - 1 && idx == numberOfItems - 1;
                if ([cell.displayingContext.camment.uuid isEqualToString:[CMStore instance].playingCammentId])
                {
                    if (!isFirst && !isLast) {
                        top = -90/4.0f;
                    } else if (isLast && !isFirst) {
                        top = -45.0f;
                    }
                }


            }
        }
    }

    for (NSUInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [elements numberOfItemsInSection:section];

        for (NSUInteger idx = 0; idx < numberOfItems; idx++) {
            CGFloat leftLayoutGuide = 20.0f;
            CGFloat topLayoutGuide = 10.0f;

            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
            ASCollectionElement *element = [elements elementForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

            ASSizeRange sizeRange = [self _sizeRangeForItem:element.node atIndexPath:indexPath withLayoutWidth:layoutWidth info:nil];
            CGSize size = [element.node layoutThatFits:sizeRange].size;

            UIEdgeInsets layoutGuidesOffsets = UIEdgeInsetsZero;
            if ([element.node conformsToProtocol:@protocol(CMAlignableCell)]) {
                id<CMAlignableCell> cell = (id)element.node;
                layoutGuidesOffsets = [cell layoutGuidesOffsets];
            }
            top -= layoutGuidesOffsets.top;
            leftLayoutGuide -= layoutGuidesOffsets.left;

            CGPoint position = CGPointMake(leftLayoutGuide, top);
            CGRect frame = CGRectMake(position.x, position.y, size.width, size.height);

            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:element];
            top += size.height + topLayoutGuide;
        }
    }

    CGFloat contentHeight = top;
    CGSize contentSize = CGSizeMake(layoutWidth, contentHeight);
    return [[ASCollectionLayoutState alloc] initWithContext:context
                                                contentSize:contentSize
                             elementToLayoutAttributesTable:attrsMap];

    return nil;
}

+ (ASSizeRange)_sizeRangeForItem:(ASCellNode *)item
                     atIndexPath:(NSIndexPath *)indexPath
                 withLayoutWidth:(CGFloat)layoutWidth
                            info:(id)info
{
//    if ([item isKindOfClass:[CMCammentCell class]]) {
//        CMCammentCell *cell = (CMCammentCell *)item;
//        CGFloat itemWidth = 45.0f;
//        if ([cell.displayingContext.camment.uuid isEqualToString:[CMStore instance].playingCammentId]) {
//            itemWidth = 90.0f;
//        }
//        return ASSizeRangeMake(CGSizeMake(itemWidth, itemWidth), CGSizeMake(layoutWidth, itemWidth));
//    }

    return ASSizeRangeMake(CGSizeZero, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX));
}

@end
