//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CammentsBlockItem;
@protocol CMPresentationBuilder;

extern NSString * const kCMPresentationBuilderUtilityAnyShowUUID;

@interface CMPresentationUtility : NSObject

+ (NSArray<id<CMPresentationBuilder>> *)activePresentations;

- (CammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url;
- (CammentsBlockItem *)blockItemCammentWithLocalVideo:(NSString *)filename;

@end