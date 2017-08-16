/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMShowType.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMAPIShow.h"

typedef void (^CMShowTypeVideoMatchHandler)(CMAPIShow *show);
typedef void (^CMShowTypeHtmlMatchHandler)(NSString *webURL);

@interface CMShowType : NSObject <NSCopying>

+ (instancetype)htmlWithWebURL:(NSString *)webURL;

+ (instancetype)videoWithShow:(CMAPIShow *)show;

- (void)matchVideo:(CMShowTypeVideoMatchHandler)videoMatchHandler html:(CMShowTypeHtmlMatchHandler)htmlMatchHandler;

@end

