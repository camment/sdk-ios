//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMCammentsBlockItem.h"

@interface CMPresentationState : NSObject

@property (nonatomic, assign) NSTimeInterval timestamp;
@property (nonatomic, strong) NSArray<CMCammentsBlockItem *> *items;

@end