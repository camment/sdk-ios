//
// Created by Alexander Fedosov on 01.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPresentationActionInterface.h"

@class CMCammentsBlockItem;


@interface CMDisplayCammentPresentationAction : NSObject<CMPresentationActionInterface>

- (instancetype)initWithItem:(CMCammentsBlockItem *)item;

@end