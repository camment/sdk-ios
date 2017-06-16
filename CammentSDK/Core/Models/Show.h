/**
 * This file is generated using the remodel generation script.
 * The name of the input file is Show.value
 */

#import <Foundation/Foundation.h>
#import "ShowType.h"

@interface Show : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *url;
@property (nonatomic, readonly, copy) ShowType *showType;

- (instancetype)initWithUuid:(NSString *)uuid url:(NSString *)url showType:(ShowType *)showType;

@end

