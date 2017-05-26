//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class CMStreamPlayerNode;
@class CMCammentsBlockNode;
@class CMCammentButton;
@class CMCammentRecorderPreviewNode;


@interface CMCammentsInStreamPlayerNode: ASDisplayNode

@property(nonatomic, strong) CMStreamPlayerNode *streamPlayerNode;
@property(nonatomic, strong) CMCammentsBlockNode *cammentsBlockNode;
@property(nonatomic, strong) CMCammentRecorderPreviewNode *cammentRecorderNode;
@property(nonatomic, strong) CMCammentButton *cammentButton;
@property(nonatomic, assign) BOOL showCammentsBlock;
@property(nonatomic, assign) BOOL showCammentRecorderNode;

@end