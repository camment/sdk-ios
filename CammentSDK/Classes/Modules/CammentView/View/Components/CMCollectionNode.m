//
// Created by Alexander Fedosov on 22.02.2018.
//

#import "CMCollectionNode.h"


@implementation CMCollectionNode {

}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    return ([self indexPathForItemAtPoint:point] != Nil);
}

@end