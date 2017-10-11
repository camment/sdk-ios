//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenter.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import "CMCammentsInStreamPlayerPresenter.h"
#import "CMShow.h"
#import "CMLoadingHUD.h"
#import "CMAPIDevcammentClient.h"
#import "CMAPIDevcammentClient+defaultApiClient.h"

@interface CMCammentsInStreamPlayerPresenter ()

@property(nonatomic, strong) CMShow *show;

@end

@implementation CMCammentsInStreamPlayerPresenter

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];

    if (self) {
        self.show = show;
    }

    return self;
}

- (void)setupView {
    if (_show.uuid && !_show.url) {
        [self.output showLoadingHUD];
        [self getShowInfo:_show.uuid];
    } else {
        [self startShow:_show];
    }
}

- (void)startShow:(CMShow *)show {
    [self.output hideLoadingHUD];
    [self.output startShow:show];
}


- (void)getShowInfo:(NSString *)uuid {
    AWSTask *loadShowInfo = [[CMAPIDevcammentClient defaultAPIClient] showsUuidGet:uuid];
    if (!loadShowInfo) {
        [self.output hideLoadingHUD];
        return;
    }

    [loadShowInfo continueWithBlock:^id(AWSTask<CMAPIShow *> *t) {

        if (t.error || ![t.result isKindOfClass:[CMAPIShow class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.output hideLoadingHUD];
            });
            return nil;
        }

        CMAPIShow *cmapiShow = t.result;
        CMShow *updatedShow = [[CMShow alloc]
                initWithUuid:cmapiShow.uuid
                         url:cmapiShow.url
                   thumbnail:cmapiShow.thumbnail
                    showType:[CMShowType videoWithShow:cmapiShow]
                               startsAt:cmapiShow.startAt];
        self.show = updatedShow;

        dispatch_async(dispatch_get_main_queue(), ^{
            [self startShow:self.show];
        });

        return nil;
    }];
}

@end
