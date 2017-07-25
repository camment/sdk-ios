//
// Created by Alexander Fedosov on 24.07.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import "RACSignal+SignalHelpers.h"


@implementation RACSignal (SignalHelpers)

+ (RACSignal *)signalWithNext:(id)next disposable:(RACDisposable *)disposable {
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [subscriber sendNext:next];
        return disposable;
    }];
};

+ (RACSignal *)signalWithNext:(id)next {
    return [RACSignal signalWithNext:next disposable:nil];
};

@end