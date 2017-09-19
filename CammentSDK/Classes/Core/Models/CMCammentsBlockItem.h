/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMCammentsBlockItem.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMCamment.h"
#import "CMBotCamment.h"

typedef void (^CMCammentsBlockItemCammentMatchHandler)(CMCamment *camment);
typedef void (^CMCammentsBlockItemBotCammentMatchHandler)(CMBotCamment *botCamment);

@interface CMCammentsBlockItem : NSObject <NSCopying>

+ (instancetype)botCammentWithBotCamment:(CMBotCamment *)botCamment;

+ (instancetype)cammentWithCamment:(CMCamment *)camment;

- (void)matchCamment:(CMCammentsBlockItemCammentMatchHandler)cammentMatchHandler botCamment:(CMCammentsBlockItemBotCammentMatchHandler)botCammentMatchHandler;

@end

