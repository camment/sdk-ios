//
// Created by Alexander Fedosov on 22.05.2018.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@interface CMContainerNode<__covariant MasterNodeType : ASDisplayNode *, __covariant DetailsNodeType : ASDisplayNode *> : ASDisplayNode

@property (nonatomic, assign) BOOL showDetails;
@property (nonatomic, weak) MasterNodeType masterNode;
@property (nonatomic, weak) DetailsNodeType detailsNode;

- (instancetype)initWithMasterNode:(MasterNodeType *)masterNode;

+ (instancetype)nodeWithMasterNode:(ASDisplayNode *)masterNode;


@end