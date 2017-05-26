//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStreamPlayerNode.h"
#import "CMStore.h"


@interface CMStreamPlayerNode ()
@property(nonatomic, strong) ASVideoPlayerNode *videoPlayerNode;
@property(nonatomic, strong) RACDisposable *disposable;
@end

@implementation CMStreamPlayerNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.debugName = @"CMStreamPlayerNode";
        self.videoPlayerNode = [ASVideoPlayerNode new];
        self.videoPlayerNode.gravity = AVLayerVideoGravityResizeAspectFill;
        self.videoPlayerNode.shouldAutoRepeat = YES;
        self.videoPlayerNode.shouldAutoPlay = YES;
        self.automaticallyManagesSubnodes = YES;
        __weak typeof(self) __weakSelf = self;
        CMStore *store = [CMStore instance];
        _disposable = [[RACSignal combineLatest:@[
                RACObserve(store, isRecordingCamment),
                RACObserve(store, playingCammentId)
        ]] subscribeNext:^(RACTuple *tuple) {
            typeof(__weakSelf) strongSelf = __weakSelf;
            if (!strongSelf) { return; }
            BOOL isRecording = [(NSNumber *)tuple.first boolValue];
            BOOL isPlaying = [(NSNumber *)tuple.second integerValue] != kCMStoreCammentIdIfNotPlaying;
            [strongSelf.videoPlayerNode setMuted:isRecording || isPlaying];
        }];
    }

    return self;
}

- (void)dealloc {
    [self.disposable dispose];
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"backgroundStream" ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AVAsset *asset = [AVAsset assetWithURL:fileURL];
    _videoPlayerNode.asset = asset;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f)
                                                  child:_videoPlayerNode];
}


@end