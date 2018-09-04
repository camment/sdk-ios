//
//  CMSofaInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 29/08/2018.
//

#import "CMSofaInteractor.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@implementation CMSofaInteractor

- (BFTask *)fetchSofaViewForShow:(NSString *)uuid {
    BFTaskCompletionSource *taskCompletionSource = [BFTaskCompletionSource new];
    [[[CMAPIDevcammentClient defaultAPIClient] sofaShowUuidGet:uuid] continueWithBlock:^id(AWSTask *t) {
        if (t.error) {
            [taskCompletionSource setError:t.error];
        } else {
            [taskCompletionSource setResult:t.result];
        }
        return nil;
    }];

    return taskCompletionSource.task;
}

@end
