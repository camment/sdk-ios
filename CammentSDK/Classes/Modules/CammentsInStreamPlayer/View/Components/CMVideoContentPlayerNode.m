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
        self.videoPlayerNode.shouldAutoPlay = YES;
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

- (void)setMuted:(BOOL)muted {
    [self.videoPlayerNode.videoNode.player setVolume:muted ? 0.3f : 1.0f];
}

- (void)setLowVolume:(BOOL)lowVolume {
//    FBTweakCollection *collection = [[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Settings"]
//            tweakCollectionWithName:@"Video player settings"];
//    CGFloat value = [([collection tweakWithIdentifier:@"Volume"].currentValue ?: [collection tweakWithIdentifier:@"Volume"].defaultValue) floatValue] / 100;
    [self.videoPlayerNode.videoNode.player setVolume:lowVolume ? 0.7f : 1.0f];
}

- (BOOL)videoPlayerNode:(ASVideoPlayerNode*)videoPlayer shouldChangeVideoNodeStateTo:(ASVideoNodePlayerState)state {
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

@end
