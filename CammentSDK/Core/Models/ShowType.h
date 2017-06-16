/**
 * This file is generated using the remodel generation script.
 * The name of the input file is ShowType.adtValue
 */

#import <Foundation/Foundation.h>
#import "CMShow.h"

typedef void (^ShowTypeVideoMatchHandler)(CMShow *show);
typedef void (^ShowTypeHtmlMatchHandler)(NSString *webURL);

@interface ShowType : NSObject <NSCopying>

+ (instancetype)htmlWithWebURL:(NSString *)webURL;

+ (instancetype)videoWithShow:(CMShow *)show;

- (void)matchVideo:(ShowTypeVideoMatchHandler)videoMatchHandler html:(ShowTypeHtmlMatchHandler)htmlMatchHandler;

@end

