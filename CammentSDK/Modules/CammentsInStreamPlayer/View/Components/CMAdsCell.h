//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Ads;


@interface CMAdsCell: ASCellNode
- (instancetype)initWithAds:(Ads *)ads;
@end