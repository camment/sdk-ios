//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMCamment;


@interface CMCammentNode: ASDisplayNode

@property(nonatomic, copy) CMCamment *camment;
@property(nonatomic, strong) ASVideoNode *videoPlayerNode;
@property(nonatomic, copy) dispatch_block_t onStoppedPlaying;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCamment:(CMCamment *)camment;
- (void)playCamment;
- (void)stopCamment;

- (BOOL)isPlaying;
@end
