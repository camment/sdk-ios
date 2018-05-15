//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMContentViewerNode.h"

@interface CMVideoContentPlayerNode : ASDisplayNode<CMContentViewerNode>

@property (nonatomic, weak) id<CMVideoContentNodeDelegate> videoNodeDelegate;
@property (nonatomic, strong) NSDate *startsAt;

- (void)setMuted:(BOOL)muted;

- (void)setLowVolume:(BOOL)lowVolume;

- (void)getCurrentTimestamp;
@end
