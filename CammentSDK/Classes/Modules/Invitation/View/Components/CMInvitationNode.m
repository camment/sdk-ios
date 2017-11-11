//
//  CMInvitationCMInvitationNode.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 26/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMInvitationNode.h"

@interface CMInvitationNode ()
@end

@implementation CMInvitationNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isNoFriendsFound = NO;

        self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        self.noFriendsTextNode = [ASTextNode new];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentCenter;

        self.noFriendsTextNode.attributedText = [[NSAttributedString alloc]
                initWithString:@"Here will be a list of your Facebook friends as soon as they sign up in Camment"
                    attributes:@{
                            NSForegroundColorAttributeName: [UIColor blackColor],
                            NSFontAttributeName: [UIFont systemFontOfSize:18],
                            NSParagraphStyleAttributeName: paragraphStyle,
                    }];

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    UIEdgeInsets edgeInsets = _isNoFriendsFound ? UIEdgeInsetsMake(20.0f, 20.0f, 20.0f, 20.0f) : UIEdgeInsetsZero;
    id<ASLayoutElement> node = !_isNoFriendsFound ? _tableNode:
            [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY
                                                       sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY
                                                               child:_noFriendsTextNode];
  return [ASInsetLayoutSpec insetLayoutSpecWithInsets:edgeInsets child:node];
}

- (void)setInvitationListDelegate:(id <CMInvitationListDelegate>)delegate {
    self.tableNode.delegate = delegate;
    self.tableNode.dataSource = delegate;
    [delegate setItemListDisplayNode:self.tableNode];
}

@end
