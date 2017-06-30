//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMContentViewerNode.h"

@interface CMVideoContentPlayerNode : ASDisplayNode<CMContentViewerNode>


- (void)setMuted:(BOOL)muted;

- (void)setLowVolume:(BOOL)lowVolume;
@end
