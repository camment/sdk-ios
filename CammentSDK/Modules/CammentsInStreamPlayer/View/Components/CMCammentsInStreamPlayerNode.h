//
// Created by Alexander Fedosov on 20.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDisplayNode.h"
#import "CMContentViewerNode.h"

@class CMCammentsOverlayViewNode;
@class CMCammentOverlayController;

@interface CMCammentsInStreamPlayerNode : ASDisplayNode

@property (nonatomic, strong) UIView *cammentsOverlayView;
@property(nonatomic, strong) id<CMContentViewerNode> contentViewerNode;
@property(nonatomic) enum CMContentType contentType;

@end