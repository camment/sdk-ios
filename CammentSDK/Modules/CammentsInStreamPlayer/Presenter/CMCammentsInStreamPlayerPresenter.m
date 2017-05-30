//
//  CMCammentsInStreamPlayerCMCammentsInStreamPlayerPresenter.m
//  Camment
//
//  Created by Alexander Fedosov on 15/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentsInStreamPlayerPresenter.h"
#import "CMCammentsInStreamPlayerWireframe.h"
#import "CMCammentsBlockPresenter.h"
#import "CMStore.h"
#import "Camment.h"
#import "CMCammentRecorderInteractorInput.h"
#import "CMShow.h"
#import "CMCammentUploader.h"
#import "CMDevcammentClient.h"

@interface CMCammentsInStreamPlayerPresenter ()
@property (nonatomic, strong) CMCammentsBlockPresenter *cammentsBlockNodePresenter;
@property (nonatomic, strong) CMShow *show;
@end

@implementation CMCammentsInStreamPlayerPresenter

- (instancetype)initWithShow:(CMShow *)show {
    self = [super init];

    if (self) {
        self.show = show;
        self.cammentsBlockNodePresenter = [CMCammentsBlockPresenter new];

        __weak typeof(self) weakSelf = self;
        [RACObserve([CMStore instance], playingCammentId) subscribeNext:^(NSString *nextId) {
            [weakSelf playCamment:nextId];
        }];

        [[RACObserve([CMStore instance], isRecordingCamment) flattenMap:^RACSignal *(NSNumber *isRecording) {
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) { return nil; }
            if (![isRecording boolValue]) {
                [self.recorderInteractor stopRecording];
                return nil;
            }

            return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendNext:isRecording];
                return nil;
            }] delay: 0.0f];
        }] subscribeNext:^(id x) {
            [[CMStore instance] setPlayingCammentId: kCMStoreCammentIdIfNotPlaying];
            [self.recorderInteractor startRecording];
            NSLog(@"recordind...");
        }];
    }

    return self;
}

- (void)setupView {
    [self.output startShow:_show];
    [self.recorderInteractor configureCamera];
    [self.output presenterDidRequestViewPreviewView];
    [self.output setCammentsBlockNodeDelegate:_cammentsBlockNodePresenter];
    [self.interactor fetchCachedCamments:_show.uuid];
}

- (void)reloadCamments {
    [_cammentsBlockNodePresenter.collectionNode reloadData];
}

- (void)didFetchCamments:(NSArray<Camment *> *)camments {
    _cammentsBlockNodePresenter.items = camments;
    [self reloadCamments];
}

- (void)playCamment:(NSString *)cammentId {
    [_cammentsBlockNodePresenter playCamment: cammentId];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    [_recorderInteractor connectPreviewViewToRecorder:view];
}

- (void)recorderDidFinishAVAsset:(AVAsset *)asset uuid:(NSString *)uuid {
    if (asset) {
        //if (CMTimeGetSeconds(asset.duration) < 0.5) { return; }
        NSString *cammentId = [NSUUID new].UUIDString;
        Camment *camment = [[Camment alloc] initWithShowUUID:_show.uuid
                                                 cammentUUID:cammentId
                                                   remoteURL:nil
                                                    localURL:nil
                                                  localAsset:asset
                                               temporaryUUID:uuid];
        [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem cammentWithCamment:camment]];
    }
}

- (void)recorderDidFinishExportingToURL:(NSURL *)url uuid:(NSString *)uuid {
    [[[[CMCammentUploader instance] uploadVideoAsset:url
                                               uuid:uuid] deliverOnMainThread] subscribeCompleted:^{
        CMCammentInRequest *cammentInRequest = [[CMCammentInRequest alloc] init];
        cammentInRequest.url = [NSString stringWithFormat:@"https://s3.eu-central-1.amazonaws.com/sportacam-temp/%@.mp4", uuid];
        NSMutableArray<CammentsBlockItem *> *mutableCamments = [self.cammentsBlockNodePresenter.items mutableCopy];
        NSInteger index = [self.cammentsBlockNodePresenter.items indexOfObjectPassingTest:^BOOL(CammentsBlockItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block BOOL result = NO;

            [obj matchCamment:^(Camment *camment) {
                result = [camment.temporaryUUID isEqualToString:uuid];
            } ads:^(Ads *ads) {}];

            return result;
        }];
        if (index != NSNotFound) {
            CammentsBlockItem *cammentsBlockItem = mutableCamments[index];
            [cammentsBlockItem matchCamment:^(Camment *camment) {
                Camment *updateCamment = [[Camment alloc] initWithShowUUID:camment.showUUID
                                                               cammentUUID:camment.cammentUUID
                                                                 remoteURL:cammentInRequest.url
                                                                  localURL:camment.localURL
                                                                localAsset:camment.localAsset
                                                             temporaryUUID:camment.temporaryUUID];
                mutableCamments[index] = [CammentsBlockItem cammentWithCamment:updateCamment];
            } ads:^(Ads *ads) {}];
        }
        self.cammentsBlockNodePresenter.items = mutableCamments.copy;
        
        [[[CMDevcammentClient defaultClient] showsUuidCammentsPost:self.show.uuid
                                                              body:cammentInRequest]
         continueWithBlock:^id(AWSTask<CMCamment *> *t) {
             return nil;
         }];
    }];
}

- (void)didReceiveNewCamment:(Camment *)camment {

    NSInteger index = [self.cammentsBlockNodePresenter.items indexOfObjectPassingTest:^BOOL(CammentsBlockItem *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __block BOOL result = NO;

        [obj matchCamment:^(Camment *camment) {
            result = [camment.remoteURL isEqualToString:camment.remoteURL];
        } ads:^(Ads *ads) {}];

        return result;
    }];

    if ([camment.showUUID isEqualToString:_show.uuid] && index == NSNotFound) {
        [self.cammentsBlockNodePresenter insertNewItem:camment];
    }
}

@end
