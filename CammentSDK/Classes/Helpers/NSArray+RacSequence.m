//
// Created by Alexander Fedosov on 14.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "NSArray+RacSequence.h"
#import "ReactiveObjC.h"

@implementation NSArray (RacSequence)

- (NSArray *)map:(id _Nullable (^)(id _Nullable value))block {
    return [[self.rac_sequence map:block] array] ?: @[];
}

@end
