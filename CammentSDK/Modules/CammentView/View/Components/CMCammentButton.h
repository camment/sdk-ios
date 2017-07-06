//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol CMCammentButtonDelegate

- (void)didPressCammentButton;
- (void)didReleaseCammentButton;
- (void)didCancelCammentButton;

@end

@interface CMCammentButton: ASDisplayNode

@property (nonatomic, weak) id<CMCammentButtonDelegate> delegate;

- (void)cancelLongPressGestureRecognizer;
@end
