//
// Created by Alexander Fedosov on 02.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationActionInterface.h"
#import "CMPresentableByPresentationAction.h"


@interface CMDisplayViewControllerPresentationAction : NSObject<CMPresentationActionInterface>

- (instancetype)initWithPresentationController:(id <CMPresentableByPresentationAction>)presentationController
                                       actions:(NSDictionary<NSString *, id <CMPresentationRunableInterface>> *)actions;
@end