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

@protocol CMCammentsOverlayViewNodeDelegate<NSObject>

- (void)handleShareAction;
- (void)didCompleteLayoutTransition;

@end

@interface CMCammentsOverlayViewNode: ASDisplayNode

@property(nonatomic, strong) UIView* contentView;
@property(nonatomic, strong, readonly) ASDisplayNode* contentNode;
@property(nonatomic, strong, readonly) CMCammentsBlockNode *cammentsBlockNode;
@property(nonatomic, strong, readonly) CMCammentRecorderPreviewNode *cammentRecorderNode;
@property(nonatomic, strong, readonly) CMCammentButton *cammentButton;
@property(nonatomic, assign) BOOL showCammentsBlock;
@property(nonatomic, assign) BOOL showCammentRecorderNode;

@property(nonatomic, weak) id<CMCammentsOverlayViewNodeDelegate> delegate;

@end