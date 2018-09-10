//
// Created by Alexander Fedosov on 22.05.2018.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMDisplayNode.h"

@interface CMContainerNode<__covariant MasterNodeType : CMDisplayNode *, __covariant DetailsNodeType : CMDisplayNode *> : CMDisplayNode

@property (nonatomic, assign) BOOL showDetails;
@property (nonatomic, weak) MasterNodeType masterNode;
@property (nonatomic, weak) DetailsNodeType detailsNode;

- (instancetype)initWithMasterNode:(MasterNodeType *)masterNode;

+ (instancetype)nodeWithMasterNode:(CMDisplayNode *)masterNode;

- (void)updateInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end
