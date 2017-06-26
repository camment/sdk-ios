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
        self.tableNode = [ASTableNode new];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
  return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_tableNode];
}

- (void)setInvitationListDelegate:(id <CMInvitationListDelegate>)delegate {
    self.tableNode.delegate = delegate;
    self.tableNode.dataSource = delegate;
    [delegate setItemListDisplayNode:self.tableNode];
}


@end
