//
//  CMShowsListCMShowsListInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMShowsListInteractor.h"
#import "CMAPIDevcammentClient.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStore.h"

@implementation CMShowsListInteractor

- (void)fetchShowList:(NSString *)passcode {

#ifdef USE_INTERNAL_FEATURES
    if ([CMStore instance].isOfflineMode) {
        CMAPIShowList *offlineShows = [self getOfflineShowList];
        [self.output showListDidFetched:offlineShows];
        return;
    }
#endif

    [[[CMAPIDevcammentClient defaultClient] showsGet:passcode ?: @""] continueWithBlock:^id(AWSTask<id> *task) {
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

- (CMAPIShowList *)getOfflineShowList {

    NSString * resourcePath = [[NSBundle cammentSDKBundle] resourcePath];
    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"Shows"];
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    NSArray<CMAPIShow *> *shows = [[[directoryContents rac_sequence] filter:^BOOL(NSString *filePath) {
        return [filePath hasSuffix:@".mp4"];
    }] map:^CMAPIShow *(NSString *filePath) {
        CMAPIShow *show = [CMAPIShow new];
        NSString *fullPath = [documentsPath stringByAppendingPathComponent:filePath];
        show.uuid = [filePath.lastPathComponent stringByDeletingPathExtension];
        show.url = [NSURL fileURLWithPath:fullPath].absoluteString;
        return show;
    }].array;

    CMAPIShowList *list = [CMAPIShowList new];
    list.items = shows;
    return list;
}

@end
