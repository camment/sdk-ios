//
// Created by Alexander Fedosov on 27.11.2017.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CMCamment;


@interface CMCammentCellDisplayingContext : NSObject

@property CMCamment *camment;
@property BOOL shouldShowDeliveryStatus;

- (instancetype)initWithCamment:(CMCamment *)camment shouldShowDeliveryStatus:(BOOL)shouldShowDeliveryStatus;

+ (instancetype)contextWithCamment:(CMCamment *)camment shouldShowDeliveryStatus:(BOOL)shouldShowDeliveryStatus;


@end