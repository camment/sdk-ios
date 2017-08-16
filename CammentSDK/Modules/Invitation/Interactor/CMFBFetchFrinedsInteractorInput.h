//
// Created by Alexander Fedosov on 26.06.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC.h>

@class CMUser;

@protocol CMFBFetchFrinedsInteractorInput <NSObject>

- (RACSignal<NSArray<CMUser *> *> *)fetchFriendList:(BOOL)resetPaginationContext;
- (BOOL)isFinished;

@end
