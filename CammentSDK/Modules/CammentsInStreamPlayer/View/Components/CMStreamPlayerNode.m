//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStreamPlayerNode.h"
#import "CMStore.h"

#import <FBTweakStore.h>
#import <FBTweak.h>
#import <FBTweakCategory.h>
#import <FBTweakCollection.h>

@interface CMStreamPlayerNode () <ASVideoPlayerNodeDelegate>
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
        self.videoPlayerNode.delegate = self;
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
            BOOL isPlaying = ![(NSString *)tuple.second isEqualToString:kCMStoreCammentIdIfNotPlaying] ;
            [strongSelf.videoPlayerNode setMuted:isRecording];
            
            FBTweakCollection *collection = [[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Settings"]
                                             tweakCollectionWithName:@"Video player settings"];
            CGFloat value = [([collection tweakWithIdentifier:@"Volume"].currentValue ?: [collection tweakWithIdentifier:@"Volume"].defaultValue) floatValue] / 100;
            [strongSelf.videoPlayerNode.videoNode.player setVolume:isPlaying ? value : 1];
        }];

    }

    return self;
}

- (void)playVideoAtURL:(NSURL *)url {
    self.videoPlayerNode.assetURL = url;
}

- (void)dealloc {
    [self.disposable dispose];
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(.0f, .0f, .0f, .0f)
                                                  child:_videoPlayerNode];
}

- (void)videoPlayerNode:(ASVideoPlayerNode *)videoPlayer didPlayToTime:(CMTime)time {
    [[CMStore instance] setCurrentShowTimeInterval:CMTimeGetSeconds(time)];
}

@end
