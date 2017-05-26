//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Camment;


@interface CMCammentNode: ASDisplayNode

@property(nonatomic, assign) Camment *camment;

- (instancetype)initWithCamment:(Camment *)camment;
- (void)playCamment;
- (void)stopCamment;

- (BOOL)isPlaying;
@end