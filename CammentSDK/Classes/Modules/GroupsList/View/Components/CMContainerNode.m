//
// Created by Alexander Fedosov on 22.05.2018.
//

#import "CMContainerNode.h"
#import "ASDimension.h"


@implementation CMContainerNode {

}

- (instancetype)initWithMasterNode:(ASDisplayNode *)masterNode {
    self = [super init];
    if (self) {
        self.masterNode = (ASDisplayNode *) masterNode;
        self.clipsToBounds = YES;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

+ (instancetype)nodeWithMasterNode:(ASDisplayNode *)masterNode {
    return [[self alloc] initWithMasterNode:masterNode];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    NSMutableArray *children = [NSMutableArray new];

    _masterNode.style.preferredSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.height);
    _detailsNode.style.preferredSize = CGSizeMake(constrainedSize.max.width, constrainedSize.max.height);

    if (_masterNode) {[children addObject:_masterNode]; }
    if (_detailsNode) {[children addObject:_detailsNode]; }

    ASStackLayoutSpec *stackLayoutSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                 spacing:0
                                                                          justifyContent:ASStackLayoutJustifyContentStart
                                                                              alignItems:ASStackLayoutAlignItemsStretch
                                                                                children:children];
    ASInsetLayoutSpec *insetLayoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, _showDetails ? constrainedSize.max.width : .0f, .0f, .0f) child:stackLayoutSpec];
    return insetLayoutSpec;
}

- (void)animateLayoutTransition:(nonnull id <ASContextTransitioning>)context {
    if (!context.isAnimated) {
        [super animateLayoutTransition:context];
        return;
    }

    [UIView animateWithDuration:.04f
                     animations:^{
                        if (_masterNode) {
                            _masterNode.frame = [context finalFrameForNode:_masterNode];
                        }

                         if (_detailsNode) {
                             _detailsNode.frame = [context finalFrameForNode:_detailsNode];
                         }
                     }
                     completion:^(BOOL finished) {
                        [context completeTransition:finished];
                     }];
}

@end
