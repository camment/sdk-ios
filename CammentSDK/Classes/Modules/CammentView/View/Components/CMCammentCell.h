//
// Created by Alexander Fedosov on 16.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>


@class CMCammentNode;
@class CMCamment;
@class CMCammentCell;

@protocol CMCammentCellDelegate<NSObject>

- (void)cammentCellDidHandleLongPressAction:(CMCammentCell *)cell;

@end

@interface CMCammentCell : ASCellNode

@property (nonatomic, strong) CMCammentNode *cammentNode;
@property (nonatomic, assign) BOOL expanded;
@property (nonatomic, weak) id<CMCammentCellDelegate> delegate;

@property(nonatomic, strong, readonly) CMCamment *camment;

- (instancetype)initWithCamment:(CMCamment *)camment;
@end