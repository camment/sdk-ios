/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CammentsBlockItem.adtValue
 */

#import <Foundation/Foundation.h>
#import "Camment.h"
#import "Ads.h"

typedef void (^CammentsBlockItemCammentMatchHandler)(Camment *camment);
typedef void (^CammentsBlockItemAdsMatchHandler)(Ads *ads);

@interface CammentsBlockItem : NSObject <NSCopying>

+ (instancetype)adsWithAds:(Ads *)ads;

+ (instancetype)cammentWithCamment:(Camment *)camment;

- (void)matchCamment:(CammentsBlockItemCammentMatchHandler)cammentMatchHandler ads:(CammentsBlockItemAdsMatchHandler)adsMatchHandler;

@end

