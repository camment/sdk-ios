//
//  CMShowsListCMShowsListInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListInteractor.h"
#import "CMDevcammentClient.h"

@implementation CMShowsListInteractor

- (void)fetchShowList {
    [[[CMDevcammentClient defaultClient] showsGet] continueWithBlock:^id(AWSTask<id> *task) {
        if (task.error) {
            [self.output showListFetchingFailed:task.error];
            return nil;
        }

        if ([task.result isKindOfClass:[CMShowList class]]) {
            [self.output showListDidFetched:(CMShowList *)task.result];
        } else {
            [self.output showListFetchingFailed:[NSError errorWithDomain:@"ios.camment.tv" code:1 userInfo:nil]];
        }

        return nil;
    }];
}

@end