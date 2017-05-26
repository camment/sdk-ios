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

@interface CMCammentsInStreamPlayerInteractor ()
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMCammentsInStreamPlayerInteractor

- (instancetype)init {
    self = [super init];
    if (self) {
     //   disposable = [CMServerListener instanceWithCredentials:<#(CMServerListenerCredentials *)credentials#>]
    }
    return self;
}

- (void)fetchCachedCamments {

    NSMutableArray *camments = @[].mutableCopy;
    [_output didFetchCamments:camments.copy];
}

@end
