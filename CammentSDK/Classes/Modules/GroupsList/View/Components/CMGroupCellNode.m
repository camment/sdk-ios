//
// Created by Alexander Fedosov on 20.09.17.
//

#import "ASCollectionNode.h"
#import "CMGroupCellNode.h"
#import "CMUsersGroup.h"

@interface CMGroupCellNode ()
@property(nonatomic, strong) ASTextNode *groupNameNode;
@end

@implementation CMGroupCellNode {

}

- (instancetype)initWithGroup:(CMUsersGroup *)group{
    self = [super init];
    if (self) {
        _group = group;

        self.groupNameNode = [ASTextNode new];
        self.groupNameNode.attributedText = [[NSAttributedString alloc] initWithString:group.uuid];
        self.clipsToBounds = YES;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    self.groupNameNode.style.height = ASDimensionMake(44.0f);

    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, 20, 0, INFINITY)
                                child:self.groupNameNode];
}
@end