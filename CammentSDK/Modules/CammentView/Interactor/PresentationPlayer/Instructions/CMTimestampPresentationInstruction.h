//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstruction.h"

@class CammentsBlockItem;


@interface CMTimestampPresentationInstruction: CMPresentationInstruction

@property (nonatomic, assign) NSTimeInterval timestamp;

- (instancetype)initWithTimestamp:(NSTimeInterval)timestamp action:(id <CMPresentationActionInterface>)action;
@end