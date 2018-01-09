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

- (void)layout {
    [super layout];
    self.videoPlayerNode.gravity = self.bounds.size.height > self.bounds.size.width ? AVLayerVideoGravityResizeAspect : AVLayerVideoGravityResizeAspectFill;
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
    [[CMStore instance] setCurrentShowTimeInterval:CMTimeGetSeconds(time)];
}

- (void)setMuted:(BOOL)muted {
    _muted = muted;
    [self setVolume:muted ? 0.05f : 1.0f];
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
    [self setVolume:lowVolume ? 0.3f : 1.0f];
}

- (BOOL)videoPlayerNode:(ASVideoPlayerNode *)videoPlayer shouldChangeVideoNodeStateTo:(ASVideoNodePlayerState)state {
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

@end
