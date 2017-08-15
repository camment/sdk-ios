//
//  CMShowsListCMShowsListInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListInteractor.h"
#import "CMAPIDevcammentClient.h"

@implementation CMShowsListInteractor

- (void)fetchShowList {
    [[[CMAPIDevcammentClient defaultClient] showsGet] continueWithBlock:^id(AWSTask<id> *task) {
        if (task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output showListFetchingFailed:task.error];
            });
            return nil;
        }

        if ([task.result isKindOfClass:[CMAPIShowList class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output showListDidFetched:(CMAPIShowList *)task.result];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output showListFetchingFailed:[NSError errorWithDomain:@"ios.camment.tv" code:1 userInfo:nil]];
            });
        }

        return nil;
    }];
}

@end