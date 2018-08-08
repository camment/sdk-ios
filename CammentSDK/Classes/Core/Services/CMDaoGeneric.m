//
// Created by Alexander Fedosov on 08/08/2018.
//

#import "CMDaoGeneric.h"
#import "YapDatabase.h"


@implementation CMDaoGeneric {

}
- (instancetype)initWithDatabase:(YapDatabase *)database {
    self = [super init];
    if (self) {
        _database = database;
    }
    return self;
}

- (BFTask *)entityWithId:(NSString *)uuid {
    NSAssert(NO, @"Must be implemented in subclasses");
    return nil;
}

- (BFTask *)saveEntity:(id)entity {
    NSAssert(NO, @"Must be implemented in subclasses");
    return nil;
}

@end