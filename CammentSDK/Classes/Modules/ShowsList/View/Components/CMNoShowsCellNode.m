//
// Created by Alexander Fedosov on 10.10.2017.
//

#import "CMNoShowsCellNode.h"
#import "CMShowListNoShowsNode.h"

@interface CMNoShowsCellNode()

@property(nonatomic, strong) CMShowListNoShowsNode *noShowsNode;

@end

@implementation CMNoShowsCellNode

- (instancetype)init {

    self = [super initWithShow:nil];

    if (self) {
        self.noShowsNode = [CMShowListNoShowsNode new];

        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}


- (ASDisplayNode *)contentNode {
    return _noShowsNode;
}

@end