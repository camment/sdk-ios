//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationInstructionInterface.h"


@interface CMPresentationInstruction : NSObject<CMPresentationInstructionInterface>

@property (nonatomic, assign) BOOL wasTriggered;
@property (nonatomic, assign) BOOL shouldTriggerEveryTick;

@end