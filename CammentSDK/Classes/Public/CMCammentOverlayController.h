//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMShowMetadata.h"

@class CMCammentOverlayLayoutConfig;

@protocol CMCammentOverlayControllerDelegate<NSObject>

- (void)cammentOverlayDidRequestPlayerState:(void (^)(BOOL isPlaying, NSTimeInterval timestamp))playerStateBlock;

@optional

 - (void)cammentOverlayDidStartRecording;
 - (void)cammentOverlayDidFinishRecording;

- (void)cammentOverlayDidStartPlaying;
- (void)cammentOverlayDidFinishPlaying;

@end

@interface CMCammentOverlayController : NSObject

@property (nonatomic, weak) id<CMCammentOverlayControllerDelegate> _Nullable overlayDelegate;
@property (nonatomic, strong) NSArray<UIView *>  * _Nullable avoidTouchesInViews;

- (instancetype _Nonnull)initWithShowMetadata:(CMShowMetadata *_Nonnull)metadata;

- (instancetype _Nonnull)initWithShowMetadata:(CMShowMetadata *_Nonnull)metadata
                 overlayLayoutConfig:(CMCammentOverlayLayoutConfig *_Nonnull)overlayLayoutConfig;

- (void)addToParentViewController:(UIViewController * _Nonnull)viewController;
- (void)removeFromParentViewController;

- (UIView * _Nonnull)cammentView;

- (void)setContentView:(UIView * _Nonnull)contentView;

- (UIInterfaceOrientationMask)contentPossibleOrientationMask;

@end
