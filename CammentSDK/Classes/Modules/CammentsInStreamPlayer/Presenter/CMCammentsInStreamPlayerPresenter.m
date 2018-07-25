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
#import "CMErrorWireframe.h"
#import "CMACammentAds.h"
#import "CMAShowMetadata.h"
#import "CMABanner.h"

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

    dispatch_block_t startShowBlock = ^{
        [self.output hideLoadingHUD];
        [self.output startShow:show];
    };

    [[CMACammentAds sharedInstance] getPrerollBannerForShowWithMetadata:[CMAShowMetadata new]
                                                                success:^(CMABanner *banner) {
                                                                    if (banner) {
                                                                        [self.output showPrerollBanner:banner completion:startShowBlock];
                                                                    } else {
                                                                        startShowBlock();
                                                                    }

                                                                }
                                                                failure:^(NSError *error) {
                                                                    startShowBlock();
                                                                }];
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
                [self getShowInfoFailed:t.error];
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

- (void)getShowInfoFailed:(NSError *)error {
    [self.output hideLoadingHUD];
    [[CMErrorWireframe new] presentErrorViewWithError:error
                                     inViewController:(id) self.output];
}

@end
