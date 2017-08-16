/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCammentsBlockItem.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMCamment.h"
#import "CMAds.h"

typedef void (^CMCammentsBlockItemCammentMatchHandler)(CMCamment *camment);
typedef void (^CMCammentsBlockItemAdsMatchHandler)(CMAds *ads);

@interface CMCammentsBlockItem : NSObject <NSCopying>

+ (instancetype)adsWithAds:(CMAds *)ads;

+ (instancetype)cammentWithCamment:(CMCamment *)camment;

- (void)matchCamment:(CMCammentsBlockItemCammentMatchHandler)cammentMatchHandler ads:(CMCammentsBlockItemAdsMatchHandler)adsMatchHandler;

@end

