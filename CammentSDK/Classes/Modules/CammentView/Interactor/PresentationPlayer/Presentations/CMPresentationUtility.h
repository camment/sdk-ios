//
// Created by Alexander Fedosov on 31.05.17.
// Copyright (c) 2017 Camment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMDisplayCammentPresentationAction.h"

@class CMCammentsBlockItem;
@protocol CMPresentationBuilder;
@class CMBotAction;

extern NSString * const kCMPresentationBuilderUtilityAnyShowUUID;

@interface CMPresentationUtility : NSObject

+ (NSArray<id<CMPresentationBuilder>> *)activePresentations;

- (CMCammentsBlockItem *)blockItemAdsWithLocalGif:(NSString *)filename url:(NSString *)url;

- (CMCammentsBlockItem *)blockItemBotAction:(NSString *)filename action:(CMBotAction *)action;

- (CMCammentsBlockItem *)blockItemCammentWithLocalVideo:(NSString *)filename;

- (CMDisplayCammentPresentationAction *)displayCammentActionWithLocalVideo:(NSString *)filename;

- (CMDisplayCammentPresentationAction *)displayCammentActionWithLocalGif:(NSString *)filename url:(NSString *)url;

- (CMDisplayCammentPresentationAction *)displayBotActionWithLocalGif:(NSString *)filename action:(CMBotAction *)action;
@end