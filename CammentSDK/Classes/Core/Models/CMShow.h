/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMShow.value
 */

#import <Foundation/Foundation.h>
#import "CMShowType.h"

@interface CMShow : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *url;
@property (nonatomic, readonly, copy) NSString *thumbnail;
@property (nonatomic, readonly, copy) CMShowType *showType;
@property (nonatomic, readonly, copy) NSNumber *startsAt;

- (instancetype)initWithUuid:(NSString *)uuid url:(NSString *)url thumbnail:(NSString *)thumbnail showType:(CMShowType *)showType startsAt:(NSNumber *)startsAt;

@end

