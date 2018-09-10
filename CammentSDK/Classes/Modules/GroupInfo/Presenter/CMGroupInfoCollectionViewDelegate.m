//
//  CMGroupInfoCollectionViewDelegate.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 23.11.2017.
//

#import "CMGroupInfoCollectionViewDelegate.h"
#import "ASCollectionElement.h"
#import "CMProfileViewNode.h"
#import "CMInviteFriendsGroupInfoNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@implementation CMGroupInfoCollectionViewDelegate

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
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

            CGSize elementSize = [self _sizeForItem:element.node atIndexPath:indexPath withLayoutWidth:layoutWidth info:nil];

            if ([element.node isKindOfClass:[CMInviteFriendsGroupInfoNode class]]) {
                elementSize = CGSizeMake(elementSize.width, context.viewportSize.height - top);
            }

            CGPoint position = CGPointMake(.0f, top);
            CGRect frame = CGRectMake(position.x, position.y, elementSize.width, elementSize.height);

            attrs.frame = frame;
            [attrsMap setObject:attrs forKey:element];
            top += elementSize.height;
        }
    }

    CGFloat contentHeight = top;
    CGSize contentSize = CGSizeMake(layoutWidth, contentHeight);
    return [[ASCollectionLayoutState alloc] initWithContext:context
                                                contentSize:contentSize
                             elementToLayoutAttributesTable:attrsMap];

    return nil;
}

+ (CGSize)_sizeForItem:(ASCellNode *)item atIndexPath:(NSIndexPath *)indexPath withLayoutWidth:(CGFloat)layoutWidth info:(id)info
{
    return [item layoutThatFits:ASSizeRangeMake(CGSizeMake(layoutWidth, .0f),
            CGSizeMake(layoutWidth, CGFLOAT_MAX))].size;
}

@end
