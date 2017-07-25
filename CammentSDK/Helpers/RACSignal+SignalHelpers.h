//
// Created by Alexander Fedosov on 24.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@interface RACSignal (SignalHelpers)
+ (RACSignal *)signalWithNext:(id)next disposable:(RACDisposable *)disposable;

+ (RACSignal *)signalWithNext:(id)next;
@end