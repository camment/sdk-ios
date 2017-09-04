//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMCammentsLoaderInteractorOutput.h"

@protocol CMPresentationInstructionInterface;

@protocol CMPresentationInstructionOutput <CMCammentsLoaderInteractorOutput>

- (void)presentationInstruction:(id<CMPresentationInstructionInterface>)instruction presentsViewController:(UIViewController *)viewController;

@end