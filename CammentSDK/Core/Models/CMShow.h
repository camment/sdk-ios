/**
 * This file is generated using the remodel generation script.
 * The name of the input file is CMShow.value
 */

#import <Foundation/Foundation.h>
#import "CMShowType.h"

@interface CMShow : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString *uuid;
@property (nonatomic, readonly, copy) NSString *url;
@property (nonatomic, readonly, copy) CMShowType *showType;

- (instancetype)initWithUuid:(NSString *)uuid url:(NSString *)url showType:(CMShowType *)showType;

@end

