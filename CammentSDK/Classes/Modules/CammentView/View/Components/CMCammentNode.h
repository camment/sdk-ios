//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMCamment;


@interface CMCammentNode: ASDisplayNode

@property(nonatomic, copy) CMCamment *camment;

- (instancetype)initWithCamment:(CMCamment *)camment;
- (void)playCamment;
- (void)stopCamment;

- (BOOL)isPlaying;
@end
