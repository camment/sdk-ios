//
// Created by Alexander Fedosov on 31.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMCammentOverlayLayoutPosition) {
    CMCammentOverlayLayoutPositionTopLeft,
    CMCammentOverlayLayoutPositionTopRight,
    CMCammentOverlayLayoutPositionBottomLeft,
    CMCammentOverlayLayoutPositionBottomRight,
};

@interface CMCammentOverlayLayoutConfig : NSObject

@property (nonatomic, assign) CMCammentOverlayLayoutPosition cammentButtonLayoutPosition;

@property(nonatomic) CGFloat cammentButtonLayoutVerticalInset;
@end