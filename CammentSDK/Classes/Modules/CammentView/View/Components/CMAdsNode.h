//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#ifdef USE_FLANIMATED_IMAGE
#undef USE_FLANIMATED_IMAGE
#define USE_FLANIMATED_IMAGE
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMAds;


@interface CMAdsNode: ASDisplayNode
- (instancetype)initWithAds:(CMAds *)ads;
@end