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

@property (nonatomic, strong) ASDisplay

@end

@implementation CMGroupInfoNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
  return [super layoutSpecThatFits:constrainedSize];
}

@end
