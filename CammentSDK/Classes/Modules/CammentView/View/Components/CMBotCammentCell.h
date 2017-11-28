//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CMAlignableCell.h"

@class CMBotCamment;
@class CMBotCammentCell;


@protocol CMBotCammentCellDelegate <NSObject>

- (void)botCammentCellDidTapOnCloseButton:(CMBotCammentCell *)cell;

@end


@interface CMBotCammentCell: ASCellNode<CMAlignableCell>

@property (nonatomic, weak) id<CMBotCammentCellDelegate> delegate;
@property (nonatomic, strong) CMBotCamment *botCamment;

- (instancetype)initWithBotCamment:(CMBotCamment *)botCamment;
@end