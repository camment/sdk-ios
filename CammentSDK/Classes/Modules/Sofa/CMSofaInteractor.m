//
//  CMSofaInteractor.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 29/08/2018.
//

#import "CMSofaInteractor.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@implementation CMSofaInteractor

- (void)fetchSofaViewForShow:(NSString *)uuid {
    [[[CMAPIDevcammentClient defaultAPIClient] sofaShowUuidGet:uuid] continueWithBlock:^id _Nullable(AWSTask * _Nonnull task) {
        CMAPISofa *result = task.result;
        
        if (!task.error && [result isKindOfClass:[CMAPISofa class]]) {
            if ([self.output respondsToSelector:@selector(sofaViewDidFetchedContent:)]) {
                [self.output sofaViewDidFetchedContent:result];
            }
        } else {
            if ([self.output respondsToSelector:@selector(sofaViewDidFailedFetching:)]) {
                [self.output sofaViewDidFailedFetching:task.error];
            }
        }
        
        return nil;
    }];
}

@end
