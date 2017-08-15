/**
 * This file is generated using the remodel generation script.
 * The name of the input file is ShowType.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMAPIShow.h"

typedef void (^ShowTypeVideoMatchHandler)(CMAPIShow *show);
typedef void (^ShowTypeHtmlMatchHandler)(NSString *webURL);

@interface ShowType : NSObject <NSCopying>

+ (instancetype)htmlWithWebURL:(NSString *)webURL;

+ (instancetype)videoWithShow:(CMAPIShow *)show;

- (void)matchVideo:(ShowTypeVideoMatchHandler)videoMatchHandler html:(ShowTypeHtmlMatchHandler)htmlMatchHandler;

@end

