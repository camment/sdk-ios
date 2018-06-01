//
// Created by Alexander Fedosov on 12.10.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMProfileViewNodeContext;

@interface CMProfileViewNode : ASCellNode

- (instancetype)initWithContext:(CMProfileViewNodeContext *)context NS_DESIGNATED_INITIALIZER;

@end
