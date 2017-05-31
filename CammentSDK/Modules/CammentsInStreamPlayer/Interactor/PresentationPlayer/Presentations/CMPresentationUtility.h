//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CammentsBlockItem;


@interface CMPresentationUtility : NSObject

- (CammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url;

@end