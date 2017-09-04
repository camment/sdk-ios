//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionInterface.h"
#import "CMPresentationActionInterface.h"

@interface CMPresentationInstruction : NSObject<CMPresentationInstructionInterface>

@property (nonatomic) id<CMPresentationActionInterface> action;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL wasTriggered;
@property (nonatomic) BOOL shouldTriggerEveryTick;

@end