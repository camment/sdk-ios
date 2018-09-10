//
// Created by Alexander Fedosov on 08/08/2018.
//

#import "CMCammentDAO.h"
#import <YapDatabase/YapDatabase.h>

@implementation CMCammentDAO

- (BFTask *)entityWithId:(NSString *)uuid {

    BFTaskCompletionSource *taskCompletionSource = [BFTaskCompletionSource taskCompletionSource];

    YapDatabaseConnection *connection = [self.database newConnection];

    [connection asyncReadWithBlock:^(YapDatabaseReadTransaction *transaction) {
        CMCamment *camment = [transaction objectForKey:uuid inCollection:@"camments"];
        [taskCompletionSource setResult:camment];
    }];

    return [taskCompletionSource task];
}

- (BFTask *)saveEntity:(CMCamment *)entity {

    BFTaskCompletionSource *taskCompletionSource = [BFTaskCompletionSource taskCompletionSource];

    YapDatabaseConnection *connection = [self.database newConnection];

    [connection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction setObject:entity forKey:entity.uuid inCollection:@"camments"];
    } completionBlock:^{
        [taskCompletionSource setResult:entity];
    }];

    return [taskCompletionSource task];
}

@end