//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CMCammentsInStreamPlayerInteractorOutput;
@class CMPresentationState;
@protocol CMPresentationInstructionInterface;
@protocol CMPresentationInstructionOutput;


@interface CMPresentationPlayerInteractor : NSObject

@property (nonatomic, strong) NSArray<id<CMPresentationInstructionInterface>> *instructions;
@property (nonatomic, weak) id<CMPresentationInstructionOutput> instructionOutput;

- (void)update:(CMPresentationState *)state;

@end