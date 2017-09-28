//
// Created by Alexander Fedosov on 28.09.2017.
//

#import <Foundation/Foundation.h>
#import "ASDisplayNode.h"
#import "CMContentViewerNode.h"


@interface CMWaitContentNode : ASDisplayNode<CMContentViewerNode>

- (instancetype)initWithStartDate:(NSDate *)date NS_DESIGNATED_INITIALIZER;

@end
