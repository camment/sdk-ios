//
// Created by Alexander Fedosov on 19.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMShow, CMShowCellNode;

@protocol CMShowCellNodeDelegate<NSObject>

- (void)showCellNode:(CMShowCellNode *)node didSelectShow:(CMShow *)show;

@end

@interface CMShowCellNode: ASCellNode

@property (nonatomic, strong, readonly) CMShow *show;
@property (nonatomic, weak) id<CMShowCellNodeDelegate> delegate;

- (instancetype)initWithShow:(CMShow *)show;

- (void)playPressAnimation;

- (void)cancelTapGesture;

- (UIImage *)thumbnailImage;
@end