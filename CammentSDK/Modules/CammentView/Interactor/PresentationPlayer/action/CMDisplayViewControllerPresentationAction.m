//
// Created by Alexander Fedosov on 02.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "CMDisplayViewControllerPresentationAction.h"
#import "CMPresentableByPresentationAction.h"
#import <UIKit/UIKit.h>

@interface CMDisplayViewControllerPresentationAction ()
@property(nonatomic, strong) id<CMPresentableByPresentationAction> presentationController;
@property(nonatomic, strong) NSDictionary<NSString *, id <CMPresentationRunableInterface>> *actions;
@end

@implementation CMDisplayViewControllerPresentationAction


- (instancetype)initWithPresentationController:(id <CMPresentableByPresentationAction>)presentationController actions:(NSDictionary<NSString *, id <CMPresentationRunableInterface>> *)actions {
    self = [super init];
    if (self) {
        self.presentationController = presentationController;
        self.actions = actions;
    }
    return self;
}

- (void)runWithOutput:(id <CMPresentationInstructionOutput>)output {
    [self.presentationController presentWithOutput:output actions:self.actions];
}


@end