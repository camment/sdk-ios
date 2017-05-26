//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@class CMCammentNode;
@class Camment;

@interface CMCammentCell : ASCellNode

@property (nonatomic, strong) CMCammentNode *cammentNode;
@property (nonatomic, assign) BOOL expanded;

- (instancetype)initWithCamment:(Camment *)camment;
@end