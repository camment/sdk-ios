//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Show;


@interface CMShowCellNode: ASCellNode

@property (nonatomic, strong, readonly) Show *show;

- (instancetype)initWithShow:(Show *)show;

@end