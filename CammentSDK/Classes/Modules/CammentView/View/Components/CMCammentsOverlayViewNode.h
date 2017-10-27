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

@protocol CMCammentsOverlayViewNodeDelegate<NSObject>

- (void)handleShareAction;
- (void)didCompleteLayoutTransition;

@end

@interface CMCammentsOverlayViewNode: ASDisplayNode

@property(nonatomic, weak) UIView* contentView;
@property(nonatomic, strong, readonly) ASDisplayNode* contentNode;
@property(nonatomic, strong, readonly) CMCammentsBlockNode *cammentsBlockNode;
@property(nonatomic, strong) ASDisplayNode *leftSidebarNode;
@property(nonatomic, strong, readonly) CMCammentRecorderPreviewNode *cammentRecorderNode;
@property(nonatomic, strong, readonly) CMCammentButton *cammentButton;
@property(nonatomic, strong, readonly) CMAdsVideoPlayerNode *adsVideoPlayerNode;
@property(nonatomic, assign) BOOL showCammentsBlock;
@property(nonatomic, assign) BOOL showLestSidebarNode;
@property(nonatomic, assign) BOOL showCammentRecorderNode;
@property(nonatomic, assign) BOOL showVideoAdsPlayerNode;
@property(nonatomic, assign) CGRect videoAdsPlayerNodeAppearsFrame;
@property(nonatomic, strong) CMCammentOverlayLayoutConfig *layoutConfig;

@property(nonatomic, weak) id<CMCammentsOverlayViewNodeDelegate> delegate;

- (instancetype)initWithLayoutConfig:(CMCammentOverlayLayoutConfig *)layoutConfig NS_DESIGNATED_INITIALIZER;
@end
