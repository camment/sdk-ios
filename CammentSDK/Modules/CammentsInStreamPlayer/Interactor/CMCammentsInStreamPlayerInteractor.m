//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerInteractor.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <AWSIoT/AWSIoT.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsInStreamPlayerInteractor.h"
#import "Camment.h"
#import "CMServerListener.h"
#import "CMServerListenerCredentials.h"
#import "CMServerMessage.h"
#import "CMDevcammentClient.h"

@interface CMCammentsInStreamPlayerInteractor ()
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMCammentsInStreamPlayerInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.disposable = [[[[CMServerListener instanceWithCredentials:[CMServerListenerCredentials defaultCredentials]] messageSubject] deliverOnMainThread]subscribeNext:^(CMServerMessage * _Nullable x) {
            NSDictionary *values = [x json];
            Camment *camment = [[Camment alloc]
                    initWithShowUUID:values[@"showUuid"]
                         cammentUUID:values[@"uuid"]
                           remoteURL:values[@"url"]
                            localURL:nil
                          localAsset:nil
                       temporaryUUID:nil];
            [self.output didReceiveNewCamment:camment];
        }];
    }
    return self;
}

- (void)fetchCachedCamments:(NSString *)showUUID {

//    [[[CMDevcammentClient defaultClient] showsUuidCammentsGet:showUUID] continueWithBlock:^id(AWSTask<CMCammentList *> *t) {
//
//        if ([t.result isKindOfClass:[CMCammentList class]]) {
//            NSArray *camments = [(CMCammentList *)t.result items] ;
//            [_output didFetchCamments:[camments.rac_sequence map:^id(CMCamment * value) {
//                return [[Camment alloc] initWithShowUUID:value.showUuid
//                                             cammentUUID:value.uuid
//                                               remoteURL:value.url
//                                                localURL:nil
//                                              localAsset:nil
//                                           temporaryUUID:nil];
//            }].array];
//        };
//        return nil;
//    }];
}

@end
