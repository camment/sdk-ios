//
//  CMGroupInfoCMGroupInfoNode.m
//  Pods
//
//  Created by Alexander Fedosov on 12/10/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMGroupInfoNode.h"

@interface CMGroupInfoNode ()

@property (nonatomic, strong) CMInviteFriendsGroupInfoNode *notSignedInGroupInfoNode;

@end

@implementation CMGroupInfoNode

- (instancetype)init {
    self = [super init];
    if (self) {

        self.notSignedInGroupInfoNode = [CMInviteFriendsGroupInfoNode new];

        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)setDelegate:(id <CMGroupInfoNodeDelegate>)delegate {
    _delegate = delegate;
    self.notSignedInGroupInfoNode.delegate = _delegate;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
  return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                child:_notSignedInGroupInfoNode];
}

@end
