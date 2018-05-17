//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMVideoContentPlayerNode.h"
#import "CMStore.h"

#import "FBTweakStore.h"
#import "FBTweak.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"

@interface CMVideoContentPlayerNode () <ASVideoPlayerNodeDelegate>
@property(nonatomic, strong) ASVideoPlayerNode *videoPlayerNode;
@property(nonatomic, strong) RACDisposable *disposable;
@property(nonatomic) BOOL muted;
@property(nonatomic) BOOL shouldRescheduleTimeInterval;
@end

@implementation CMVideoContentPlayerNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.debugName = @"CMStreamPlayerNode";
        self.videoPlayerNode = [ASVideoPlayerNode new];
        self.videoPlayerNode.gravity = AVLayerVideoGravityResizeAspectFill;
        self.videoPlayerNode.shouldAutoRepeat = YES;
        self.videoPlayerNode.shouldAutoPlay = NO;
        self.videoPlayerNode.delegate = self;

        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didLoad {
    [super didLoad];
}

- (void)layout {
    [super layout];
    self.videoPlayerNode.gravity = self.bounds.size.height > self.bounds.size.width ? AVLayerVideoGravityResizeAspect : AVLayerVideoGravityResizeAspectFill;
    [CMStore instance].avoidTouchesInViews = [[self.videoPlayerNode.subnodes.rac_sequence filter:^BOOL(ASDisplayNode * value) {
        return ![value isKindOfClass:[ASVideoNode class]];
    }] map:^id _Nullable(ASDisplayNode * _Nullable value) {
        return value.view;
    }].array;
}

- (void)openContentAtUrl:(NSURL *)url {
    self.videoPlayerNode.asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    [self.videoPlayerNode play];
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
    Float64 showTimeInterval = CMTimeGetSeconds(time);
    [[CMStore instance] setCurrentShowTimeInterval:showTimeInterval];
    if (self.videoNodeDelegate && [self.videoNodeDelegate respondsToSelector:@selector(playerDidUpdateCurrentTimeInterval:)]) {
        [self.videoNodeDelegate playerDidUpdateCurrentTimeInterval:showTimeInterval];
    }
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    [self setVolume:muted ? 0.02f : 1.0f];
}

- (void)setVolume:(CGFloat)volume {
    AVAsset *asset = self.videoPlayerNode.asset;

    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:volume atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioVolMix = [AVMutableAudioMix audioMix];
    [audioVolMix setInputParameters:allAudioParams];
    [self.videoPlayerNode.videoNode.player.currentItem setAudioMix:audioVolMix];
}

- (void)setLowVolume:(BOOL)lowVolume {
    if (_muted) { return; }
    [self setVolume:lowVolume ? 0.2f : 1.0f];
}

- (BOOL)videoPlayerNode:(ASVideoPlayerNode *)videoPlayer shouldChangeVideoNodeStateTo:(ASVideoNodePlayerState)state {

    [self getCurrentTimestamp:state
              completionBlock:^(BOOL isPlaying, NSTimeInterval timestamp) {
                  if (isPlaying && self.videoNodeDelegate && [self.videoNodeDelegate respondsToSelector:@selector(playerDidUpdateCurrentTimeInterval:)]) {
                      [self.videoNodeDelegate playerDidPlay:timestamp];
                  } else if (!isPlaying && self.videoNodeDelegate && [self.videoNodeDelegate respondsToSelector:@selector(playerDidUpdateCurrentTimeInterval:)]) {
                      [self.videoNodeDelegate playerDidPause:timestamp];
                  }
              }];

    if (state != ASVideoNodePlayerStatePlaying) { return YES; }

    if (self.startsAt) {
        self.videoPlayerNode.userInteractionEnabled = NO;
        NSTimeInterval seekInSec = [[NSDate date] timeIntervalSinceDate:self.startsAt];
        if (seekInSec > 0) {
            [self.videoPlayerNode.videoNode.player
                    seekToTime:CMTimeMakeWithSeconds(seekInSec, self.videoPlayerNode.videoNode.periodicTimeObserverTimescale)];
        }
    }

    return YES;
}

- (NSArray *)videoPlayerNodeNeededDefaultControls:(ASVideoPlayerNode *)videoPlayer {
    return @[];
}

- (void)videoPlayerNodeDidStartInitialLoading:(ASVideoPlayerNode *)videoPlayer {

}

- (void)videoPlayerNodeDidFinishInitialLoading:(ASVideoPlayerNode *)videoPlayer {
    
}

- (void)setCurrentTimeInterval:(NSTimeInterval)timeInterval {
    _shouldRescheduleTimeInterval = NO;
    switch (self.videoPlayerNode.playerState) {
        case ASVideoNodePlayerStatePaused:
        case ASVideoNodePlayerStatePlaying:
                [self.videoPlayerNode.videoNode.player seekToTime:CMTimeMakeWithSeconds(timeInterval, self.videoPlayerNode.videoNode.periodicTimeObserverTimescale)];
            break;
        case ASVideoNodePlayerStateUnknown:
        case ASVideoNodePlayerStateLoading:
        case ASVideoNodePlayerStateInitialLoading:
        case ASVideoNodePlayerStateReadyToPlay:
        case ASVideoNodePlayerStatePlaybackLikelyToKeepUpButNotPlaying:
            _shouldRescheduleTimeInterval = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!_shouldRescheduleTimeInterval) { return; }
                [self setCurrentTimeInterval:timeInterval];
            });
            break;
    }

}

- (void)setIsPlaying:(BOOL)playing {
    if (!playing) {
        [self.videoPlayerNode pause];
    } else if (self.videoPlayerNode.playerState != ASVideoNodePlayerStatePlaying) {
        [self.videoPlayerNode play];
    }
}

- (void)getCurrentTimestampCompletionBlock:(void(^)(BOOL isPlaying, NSTimeInterval timestamp))completion {
    [self getCurrentTimestamp:self.videoPlayerNode.playerState completionBlock:completion];
}

- (void)getCurrentTimestamp:(ASVideoNodePlayerState)state completionBlock:(void(^)(BOOL isPlaying, NSTimeInterval timestamp))completion {
    switch (state) {
        case ASVideoNodePlayerStatePlaying:
            completion(YES,CMTimeGetSeconds(self.videoPlayerNode.videoNode.player.currentTime));
            break;
        case ASVideoNodePlayerStateFinished:
        case ASVideoNodePlayerStateUnknown:
        case ASVideoNodePlayerStateInitialLoading:
        case ASVideoNodePlayerStateReadyToPlay:
        case ASVideoNodePlayerStatePlaybackLikelyToKeepUpButNotPlaying:
        case ASVideoNodePlayerStateLoading:
        case ASVideoNodePlayerStatePaused:
            completion(NO,CMTimeGetSeconds(self.videoPlayerNode.videoNode.player.currentTime));
            break;
    }
}

@end
