//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMCammentsBlockNode;
@class CMCammentButton;
@class CMCammentRecorderPreviewNode;
@protocol CMContentViewerNode;
@class CMCammentOverlayLayoutConfig;
@class CMGroupsListNode;
@class CMAdsVideoPlayerNode;
@class CMGroupInfoNode;

@protocol CMCammentsOverlayViewNodeDelegate<NSObject>

- (void)handlePanToShowSidebarGesture;
- (void)didCompleteLayoutTransition;
- (void)handleSkipTutorialAction;
@end

@interface CMCammentsOverlayViewNode: ASDisplayNode

@property(nonatomic, weak) UIView* contentView;
@property(nonatomic, strong, readonly) ASDisplayNode* contentNode;
@property(nonatomic, strong, readonly) CMCammentsBlockNode *cammentsBlockNode;
@property(nonatomic, strong) CMGroupInfoNode *leftSidebarNode;
@property(nonatomic, strong, readonly) CMCammentRecorderPreviewNode *cammentRecorderNode;
@property(nonatomic, strong, readonly) CMCammentButton *cammentButton;
@property(nonatomic, strong, readonly) CMAdsVideoPlayerNode *adsVideoPlayerNode;
@property(nonatomic, strong, readonly) ASButtonNode* skipTutorialButton;
@property(nonatomic, assign) BOOL showCammentsBlock;
@property(nonatomic, assign) BOOL showLeftSidebarNode;
@property(nonatomic, assign) BOOL showCammentRecorderNode;
@property(nonatomic, assign) BOOL showVideoAdsPlayerNode;
@property(nonatomic, assign) BOOL disableClosingCammentBlock;
@property(nonatomic, assign) BOOL showSkipTutorialButton;
@property(nonatomic, assign) CGRect videoAdsPlayerNodeAppearsFrame;
@property(nonatomic, strong) CMCammentOverlayLayoutConfig *layoutConfig;

@property(nonatomic, weak) id<CMCammentsOverlayViewNodeDelegate> delegate;

- (instancetype)initWithLayoutConfig:(CMCammentOverlayLayoutConfig *)layoutConfig NS_DESIGNATED_INITIALIZER;

- (void)updateLeftSideBarMenuLeftInset;

- (void)playSidebarJumpingAnimation;
@end
