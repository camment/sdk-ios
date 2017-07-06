//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@class CMCammentNode;
@class Camment;
@class CMCammentCell;

@protocol CMCammentCellDelegate<NSObject>

- (void)cammentCellDidHandleLongPressAction:(CMCammentCell *)cell;

@end

@interface CMCammentCell : ASCellNode

@property (nonatomic, strong) CMCammentNode *cammentNode;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, weak) id<CMCammentCellDelegate> delegate;

@property(nonatomic, strong, readonly) Camment *camment;

- (instancetype)initWithCamment:(Camment *)camment;
@end