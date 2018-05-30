//
// Created by Alexander Fedosov on 20.09.17.
//

#import "ASCollectionNode.h"
#import "CMGroupCellNode.h"
#import "CMUsersGroup.h"
#import "UIFont+CammentFonts.h"
#import "NSArray+RacSequence.h"

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
        self.groupNameNode.maximumNumberOfLines = 1;
        self.groupNameNode.truncationMode = NSLineBreakByTruncatingTail;
        self.groupNameNode.style.minHeight = ASDimensionMake(14.0f);
        self.groupNameNode.attributedText = [[NSAttributedString alloc] initWithString:[[group.users map:^id(CMUser *user) {
            return user.username;
        }] componentsJoinedByString:@", "] attributes:@{
                NSFontAttributeName: [UIFont nunitoMediumWithSize:14],
        }];
        self.clipsToBounds = YES;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {

    ASCenterLayoutSpec *centerLayoutSpec = [ASCenterLayoutSpec
            centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringY
                                   sizingOptions:ASCenterLayoutSpecSizingOptionDefault
                                           child:_groupNameNode];
    return [ASInsetLayoutSpec
            insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 20, 10, 10.0f)
                                child:centerLayoutSpec];
}
@end