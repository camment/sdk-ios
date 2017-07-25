//
// Created by Alexander Fedosov on 30.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Ads;
@class CMAdsCell;


@protocol CMAdsCellDelegate <NSObject>

- (void)adsCellDidTapOnCloseButton:(CMAdsCell *)cell;

@end


@interface CMAdsCell: ASCellNode

@property (nonatomic, weak) id<CMAdsCellDelegate> delegate;
@property (nonatomic, strong) Ads *ads;

- (instancetype)initWithAds:(Ads *)ads;
@end