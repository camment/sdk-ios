//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionInterface.h"
#import "CMPresentationInstruction.h"

@class CammentsBlockItem;

@interface CMPositionPresentationInstruction : CMPresentationInstruction

@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) NSUInteger position;

- (instancetype)initWithPosition:(NSUInteger)position action:(id <CMPresentationActionInterface>)action;
- (instancetype)initWithPosition:(NSUInteger)position action:(id <CMPresentationActionInterface>)action delay:(NSTimeInterval)delay;

@end
