//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CMCammentViewController;
@class Show;

@protocol CMCammentOverlayControllerDelegate<NSObject>

@optional

 - (void)cammentOverlayDidStartRecording;
 - (void)cammentOverlayDidFinishRecording;

- (void)cammentOverlayDidStartPlaying;
- (void)cammentOverlayDidFinishPlaying;

@end

@interface CMCammentOverlayController : NSObject

@property (nonatomic, weak) id<CMCammentOverlayControllerDelegate> _Nullable delegate;

- (instancetype _Nonnull)initWithShow:(Show * _Nonnull)show;

- (void)addToParentViewController:(UIViewController * _Nonnull)viewController;
- (void)removeFromParentViewController;

- (UIView * _Nonnull)cammentView;

- (void)setContentView:(UIView * _Nonnull)contentView;

- (UIInterfaceOrientationMask)contentPossibleOrientationMask;
@end
