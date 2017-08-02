//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationRunableInterface.h"
#import "CMPresentationState.h"

@protocol CMPresentationInstructionInterface <NSObject, CMPresentationRunableInterface>

- (BOOL)shouldBeTriggeredForState:(CMPresentationState *)state;

@end
