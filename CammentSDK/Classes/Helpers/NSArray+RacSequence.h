//
// Created by Alexander Fedosov on 14.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RacSequence)

- (NSArray *)map:(id _Nullable (^)(id _Nullable value))block;

@end