/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMBotCamment.value
 */

#import <Foundation/Foundation.h>
#import "CMBotAction.h"

@interface CMBotCamment : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *URL;
@property (nonatomic, readonly, copy) CMBotAction *botAction;

- (instancetype)initWithURL:(NSString *)URL botAction:(CMBotAction *)botAction;

@end

