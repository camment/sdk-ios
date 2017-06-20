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
@property (nonatomic, strong) CammentsBlockItem *item;

- (instancetype)initWithPosition:(NSUInteger)position item:(CammentsBlockItem *)item;
- (instancetype)initWithPosition:(NSUInteger)position item:(CammentsBlockItem *)item delay:(NSTimeInterval)delay;

@end
