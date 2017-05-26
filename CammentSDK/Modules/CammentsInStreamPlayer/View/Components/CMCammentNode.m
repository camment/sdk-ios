//
// Created by Alexander Fedosov on 15.05.17.
// Copyright (c) 2017 Sportacam. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CMCammentNode.h"
#import "Camment.h"
#import "CMStore.h"

@interface CMCammentNode () <ASVideoNodeDelegate>
@property(nonatomic, strong) ASVideoNode *videoPlayerNode;
@end

@implementation CMCammentNode

- (instancetype)initWithCamment:(Camment *)camment {
    self = [super init];
    if (self) {

        self.camment = camment;
        self.videoPlayerNode = [ASVideoNode new];
        self.videoPlayerNode.shouldAutorepeat = NO;
        self.videoPlayerNode.shouldAutoplay = NO;
        self.videoPlayerNode.muted = NO;
        self.videoPlayerNode.delegate = self;
        self.videoPlayerNode.userInteractionEnabled = NO;
        self.automaticallyManagesSubnodes = YES;
    }

    return self;
}

- (void)didEnterPreloadState {
    [super didEnterPreloadState];
    if (_camment.localAsset) {
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:_camment.localAsset];
        CMTime time = CMTimeMake(1, 1);
        CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
        CIImage * ciimage = [[CIImage alloc] initWithCGImage:imageRef];
        CIFilter * filter = [CIFilter filterWithName:@"CIColorControls"
                                 withInputParameters:
                                         @{
                                                 kCIInputSaturationKey : @0.0,
                                                 kCIInputImageKey : ciimage
                                         }
        ];
        CIImage * grayscale  = [filter outputImage];
        UIImage *thumbnail = [UIImage imageWithCIImage:grayscale];
        CGImageRelease(imageRef);

        _videoPlayerNode.asset = _camment.localAsset;
        [_videoPlayerNode setImage:thumbnail];
        return;
    }

    NSURL *assetURL;
    if (_camment.localURL != nil) {
        assetURL = [[NSURL alloc] initFileURLWithPath:_camment.localURL];
    } else if (_camment.remoteURL != nil) {
        assetURL = [[NSURL alloc] initWithString:_camment.remoteURL];
    }

    if (assetURL == nil) { return; }
    _videoPlayerNode.asset = [AVAsset assetWithURL:assetURL];
}


- (void)playCamment {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        NSLog(@"Coudn't play camment in background thread!");
        return;
    }

    [_videoPlayerNode.player seekToTime:kCMTimeZero];
    [_videoPlayerNode play];
}

- (void)stopCamment {
    if ([NSThread currentThread] != [NSThread mainThread]) {
        NSLog(@"Coudn't stop camment in background thread!");
        return;
    }

    [_videoPlayerNode.player pause];
    [_videoPlayerNode resetToPlaceholder];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec *layoutSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero
                                                                           child:[ASRatioLayoutSpec ratioLayoutSpecWithRatio:1.0f
                                                                                                                       child:_videoPlayerNode]];
    return layoutSpec;
}

- (BOOL)isPlaying {
    return [_videoPlayerNode isPlaying];
}

- (void)videoDidPlayToEnd:(ASVideoNode *)videoNode {
    [[CMStore instance] setPlayingCammentId: kCMStoreCammentIdIfNotPlaying];
}


@end