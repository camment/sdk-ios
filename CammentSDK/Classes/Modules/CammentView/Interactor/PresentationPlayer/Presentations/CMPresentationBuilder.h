//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBTweakCategory.h"

@protocol CMBot;

@protocol CMPresentationBuilder <NSObject>

- (NSString *)presentationName;
- (NSArray *)instructions;
- (NSArray<id<CMBot>> *)bots;
- (void)configureTweaks:(FBTweakCategory *)category;

@end
