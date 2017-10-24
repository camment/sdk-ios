//
// Created by Alexander Fedosov on 31.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CMCammentOverlayLayoutPosition) {
    CMCammentOverlayLayoutPositionTopRight,
    CMCammentOverlayLayoutPositionBottomRight,
};

@interface CMCammentOverlayLayoutConfig : NSObject

// Position for camment button
// Default is CMCammentOverlayLayoutPositionTopRight;
@property (nonatomic, assign) CMCammentOverlayLayoutPosition cammentButtonLayoutPosition;

// Vertical space between camment button and nearest screen side
// Depends on cammentButtonLayoutPosition property
// For 'CMCammentOverlayLayoutPositionTopRight' it is a space between camment button and screen top
// For 'CMCammentOverlayLayoutPositionBottomRight' it is a space between camment button and screen bottom
// Default is 20.0f
@property (nonatomic) CGFloat cammentButtonLayoutVerticalInset;

// Minimum value is 200.0f, everything less than that will be changed to 200.0f;
// Default is 240.0f
@property (nonatomic) CGFloat leftSidebarWidth;

+ (CMCammentOverlayLayoutConfig *)defaultLayoutConfig;

@end
