//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMShow;


@interface CMShowCellNode: ASCellNode

@property (nonatomic, strong, readonly) CMShow *show;

- (instancetype)initWithShow:(CMShow *)show;

@end