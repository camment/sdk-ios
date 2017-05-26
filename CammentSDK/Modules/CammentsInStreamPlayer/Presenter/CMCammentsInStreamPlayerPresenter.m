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
        [RACObserve([CMStore instance], playingCammentId) subscribeNext:^(NSNumber *nextId) {
            [weakSelf playCamment:nextId.integerValue];
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
            [[CMStore instance] setPlayingCammentId: -1];
            [self.recorderInteractor startRecording];
            NSLog(@"recordind...");
        }];
    }

    return self;
}

- (void)setupView {
    [self.recorderInteractor configureCamera];
    [self.output presenterDidRequestViewPreviewView];
    [self.output setCammentsBlockNodeDelegate:_cammentsBlockNodePresenter];
    [self.interactor fetchCachedCamments];
}

- (void)reloadCamments {
    [_cammentsBlockNodePresenter.collectionNode reloadData];
}

- (void)didFetchCamments:(NSArray<Camment *> *)camments {
    _cammentsBlockNodePresenter.camments = camments;
    [self reloadCamments];
}

- (void)playCamment:(NSInteger)cammentId {
    [_cammentsBlockNodePresenter playCamment: cammentId];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    [_recorderInteractor connectPreviewViewToRecorder:view];
}

- (void)recorderDidFinishAVAsset:(AVAsset *)asset {
    if (asset) {
        if (CMTimeGetSeconds(asset.duration) < 1) { return; }
        NSInteger cammentId = self.cammentsBlockNodePresenter.camments.count + 1;
        Camment *camment = [[Camment alloc] initWithCammentId:cammentId
                                                    remoteURL:nil
                                                     localURL:nil
                                                   localAsset:asset];
        [self.cammentsBlockNodePresenter insertNewCamment:camment];
    }
}

- (void)recorderDidFinishExportingToURL:(NSURL *)url {
    [[[CMCammentUploader instance] uploadVideoAsset:url] subscribeNext:^(id x) {

    }];
}

@end